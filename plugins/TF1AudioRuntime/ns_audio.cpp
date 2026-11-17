// Native adapter authored for the TF1 map porter. Public Northstar plugin ABI;
// client script ABI is pinned to the installed retail client hash below.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <bcrypt.h>
#include <xaudio2.h>
#include <x3daudio.h>
#include <filesystem>
#include <fstream>
#include <vector>
#include <array>
#include <string>
#include <map>
#include <memory>
#include <random>
#include <algorithm>
#include <cmath>
#include <cstring>
#include <stdexcept>
namespace fs=std::filesystem;
using VM=void*;
struct Registration {
 const char *name,*cpp,*help,*returns,*args;unsigned unknown1,dev;const char* shortName;unsigned unknown2,returnType=0x20;
 unsigned* external;uint64_t externalSize,unknown3,unknown4;long(*function)(VM);
};
static_assert(sizeof(Registration)==104);
struct PluginData{HMODULE handle;uint64_t size;};
struct PluginId{virtual const char* GetString(int)=0;virtual int64_t GetField(int)=0;};
struct PluginCallbacks{virtual void Init(HMODULE,const PluginData*,bool)=0;virtual void Finalize()=0;virtual bool Unload()=0;virtual void OnSqvmCreated(void*)=0;virtual void OnSqvmDestroying(void*)=0;virtual void OnLibraryLoaded(HMODULE,const char*)=0;virtual void RunFrame()=0;};
static fs::path profile;
static void log(const std::string& s){std::ofstream(profile/"logs/TF1AudioRuntime.log",std::ios::app)<<s<<'\n';}
static bool clientHash(HMODULE module){
 wchar_t filename[32768]{};if(!GetModuleFileNameW(module,filename,32768))return false;
 std::ifstream input(filename,std::ios::binary);if(!input)return false;
 BCRYPT_ALG_HANDLE alg=nullptr;BCRYPT_HASH_HANDLE hash=nullptr;
 if(BCryptOpenAlgorithmProvider(&alg,BCRYPT_SHA256_ALGORITHM,nullptr,0)<0)return false;
 DWORD size=0,used=0;BCryptGetProperty(alg,BCRYPT_OBJECT_LENGTH,reinterpret_cast<PUCHAR>(&size),4,&used,0);
 std::vector<unsigned char> object(size),buffer(1048576);std::array<unsigned char,32> digest{};
 bool ok=BCryptCreateHash(alg,&hash,object.data(),size,nullptr,0,0)>=0;
 while(ok&&input){input.read(reinterpret_cast<char*>(buffer.data()),buffer.size());if(input.gcount())ok=BCryptHashData(hash,buffer.data(),static_cast<ULONG>(input.gcount()),0)>=0;}
 if(ok)ok=BCryptFinishHash(hash,digest.data(),32,0)>=0;
 if(hash)BCryptDestroyHash(hash);BCryptCloseAlgorithmProvider(alg,0);
 static const unsigned char expected[32]={0x00,0x2b,0x36,0x48,0x7f,0xec,0x7c,0x98,0x88,0x29,0x29,0xfb,0xcc,0xdb,0x50,0x6d,0x01,0x46,0xbb,0xf3,0x27,0x0c,0xbb,0x96,0x4a,0x4d,0x21,0xc5,0xed,0xf7,0xee,0xbc};
 return ok&&!std::memcmp(digest.data(),expected,32);
}
struct Vec{float x,y,z;};
static Vec sub(Vec a,Vec b){return {a.x-b.x,a.y-b.y,a.z-b.z};}
static Vec cross(Vec a,Vec b){return {a.y*b.z-a.z*b.y,a.z*b.x-a.x*b.z,a.x*b.y-a.y*b.x};}
static float dot(Vec a,Vec b){return a.x*b.x+a.y*b.y+a.z*b.z;}
static float distance(Vec a,Vec b){Vec d=sub(a,b);return std::sqrt(dot(d,d));}
static X3DAUDIO_VECTOR audioVec(Vec a){return {a.x,a.z,a.y};}
struct Reader {
 std::ifstream input;Reader(const fs::path& p):input(p,std::ios::binary){if(!input)throw std::runtime_error("Manifest not found");}
 template<class T>T read(){T value{};if(!input.read(reinterpret_cast<char*>(&value),sizeof value))throw std::runtime_error("Truncated audio manifest");return value;}
 std::string string(){unsigned n=read<unsigned>();if(n>32768)throw std::runtime_error("Oversized audio path");std::string s(n,'\0');if(!input.read(s.data(),n))throw std::runtime_error("Truncated string");return s;}
};
struct Wave{std::array<unsigned char,64> format{};std::vector<unsigned char> pcm;};
static std::shared_ptr<Wave> loadWave(const fs::path& p){
 std::ifstream input(p,std::ios::binary);std::vector<unsigned char> data((std::istreambuf_iterator<char>(input)),{});
 if(data.size()<12||std::memcmp(data.data(),"RIFF",4)||std::memcmp(data.data()+8,"WAVE",4))throw std::runtime_error("Invalid WAV");
 auto wave=std::make_shared<Wave>();
 for(size_t at=12;at+8<=data.size();){unsigned n=0;std::memcpy(&n,data.data()+at+4,4);if(n>data.size()-at-8)throw std::runtime_error("Truncated WAV chunk");
  if(!std::memcmp(data.data()+at,"fmt ",4)){if(n<16||n>64)throw std::runtime_error("Unsupported WAV format");std::memcpy(wave->format.data(),data.data()+at+8,n);}
  if(!std::memcmp(data.data()+at,"data",4))wave->pcm.assign(data.begin()+at+8,data.begin()+at+8+n);
  at+=8+n+(n&1);
 }
 auto* format=reinterpret_cast<WAVEFORMATEX*>(wave->format.data());
 if(wave->pcm.empty()||!format->nBlockAlign||format->wBitsPerSample!=16||(format->wFormatTag!=1&&format->wFormatTag!=0xfffe)||format->nChannels<1||format->nChannels>8)throw std::runtime_error("Unsupported source PCM");
 return wave;
}
struct Event{std::string name;float radius,v0,v1,p0,p1;unsigned loop,omni,limit;std::vector<std::string> waves;};
struct Region{unsigned event;Vec origin,mins,maxs;std::vector<std::array<Vec,3>> triangles;};
struct Voice{IXAudio2SourceVoice* value=nullptr;std::shared_ptr<Wave> wave;float pitch=1;~Voice(){if(value)value->DestroyVoice();}};
struct Placement{unsigned event;Vec origin;bool played=false;std::unique_ptr<Voice> voice;};
static bool contains(const Region& r,Vec point){
 Vec p=sub(point,r.origin);if(p.x<r.mins.x||p.y<r.mins.y||p.z<r.mins.z||p.x>r.maxs.x||p.y>r.maxs.y||p.z>r.maxs.z)return false;
 Vec ray{1,.1234567f,.271828f};std::vector<float> hits;
 for(const auto& t:r.triangles){Vec e1=sub(t[1],t[0]),e2=sub(t[2],t[0]),h=cross(ray,e2);float d=dot(e1,h);if(std::abs(d)<1e-7f)continue;
  float inv=1/d;Vec s=sub(p,t[0]);float u=inv*dot(s,h);if(u<0||u>1)continue;Vec q=cross(s,e1);float v=inv*dot(ray,q);if(v<0||u+v>1)continue;
  float distance=inv*dot(e2,q);if(distance>1e-5f)hits.push_back(distance);
 }
 std::sort(hits.begin(),hits.end());unsigned count=0;float previous=-1;
 for(float hit:hits)if(previous<0||std::abs(previous-hit)>1e-3f){++count;previous=hit;}
 return count%2;
}
class Audio {
public:
 IXAudio2* engine=nullptr;IXAudio2MasteringVoice* master=nullptr;X3DAUDIO_HANDLE spatial{};unsigned channels=0;bool com=false;
 std::vector<Event> events;std::vector<Placement> placed;std::vector<Region> regions;std::map<std::string,std::shared_ptr<Wave>> samples;fs::path mod;
 std::unique_ptr<Voice> ambience;int defaultEvent=-1,currentEvent=-1;Vec listener{},angles{};float volume=0;uint64_t listenerTick=0,nextUpdate=0;std::mt19937 random{std::random_device{}()};
 void stop(){ambience.reset();placed.clear();samples.clear();events.clear();regions.clear();defaultEvent=currentEvent=-1;listenerTick=0;if(master)master->SetVolume(0);}
 void close(){stop();if(master)master->DestroyVoice();if(engine)engine->Release();master=nullptr;engine=nullptr;if(com)CoUninitialize();com=false;}
 bool initialize(){if(engine)return true;if(!com)com=SUCCEEDED(CoInitializeEx(nullptr,COINIT_MULTITHREADED));if(FAILED(XAudio2Create(&engine)))return false;if(FAILED(engine->CreateMasteringVoice(&master))){engine->Release();engine=nullptr;return false;}XAUDIO2_VOICE_DETAILS d{};master->GetVoiceDetails(&d);channels=d.InputChannels;DWORD mask=0;master->GetChannelMask(&mask);if(FAILED(X3DAudioInitialize(mask,X3DAUDIO_SPEED_OF_SOUND,spatial)))return false;master->SetVolume(0);return true;}
 float range(float a,float b){return std::uniform_real_distribution<float>(a,b)(random);}
 std::unique_ptr<Voice> create(const Event& event){
  const auto& name=event.waves[std::uniform_int_distribution<size_t>(0,event.waves.size()-1)(random)];
  if(name.find("..")!=std::string::npos||name.find(':')!=std::string::npos||name.front()=='/')throw std::runtime_error("Unsafe sample path");
  if(!samples.count(name))samples[name]=loadWave(mod/name);
  auto voice=std::make_unique<Voice>();voice->wave=samples.at(name);auto* format=reinterpret_cast<WAVEFORMATEX*>(voice->wave->format.data());
  if(FAILED(engine->CreateSourceVoice(&voice->value,format,0,2)))throw std::runtime_error("CreateSourceVoice failed");
  XAUDIO2_BUFFER buffer{};buffer.AudioBytes=static_cast<UINT32>(voice->wave->pcm.size());buffer.pAudioData=voice->wave->pcm.data();buffer.Flags=XAUDIO2_END_OF_STREAM;buffer.LoopCount=event.loop?XAUDIO2_LOOP_INFINITE:0;
  voice->pitch=range(event.p0,event.p1)/100;voice->value->SetFrequencyRatio(std::clamp(voice->pitch,.01f,2.f));voice->value->SetVolume(range(event.v0,event.v1));
  if(FAILED(voice->value->SubmitSourceBuffer(&buffer))||FAILED(voice->value->Start()))throw std::runtime_error("Submit source PCM failed");
  log("Started "+event.name+" sample="+name);return voice;
 }
 void start(const std::string& map){
  stop();if(!initialize())throw std::runtime_error("Windows audio endpoint is unavailable");
  if(map.empty()||map.find_first_not_of("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")!=std::string::npos)throw std::runtime_error("Invalid audio map name");
  fs::path manifest;for(const auto& folder:fs::directory_iterator(profile/"mods")){auto p=folder.path()/"mod/tf1_audio"/(map+".bin");if(fs::is_regular_file(p)){manifest=p;mod=folder.path()/"mod";break;}}
  Reader reader(manifest);if(reader.read<unsigned>()!=0x31414654)throw std::runtime_error("Unknown audio manifest");
  unsigned ne=reader.read<unsigned>(),np=reader.read<unsigned>(),nr=reader.read<unsigned>();defaultEvent=static_cast<int>(reader.read<unsigned>());
  if(ne>10000||np>100000||nr>10000)throw std::runtime_error("Excessive audio manifest count");
  for(unsigned i=0;i<ne;++i){Event e{};e.name=reader.string();e.radius=reader.read<float>();e.v0=reader.read<float>();e.v1=reader.read<float>();e.p0=reader.read<float>();e.p1=reader.read<float>();e.loop=reader.read<unsigned>();e.omni=reader.read<unsigned>();e.limit=reader.read<unsigned>();unsigned n=reader.read<unsigned>();if(!n||n>10000)throw std::runtime_error("Invalid wave count");for(unsigned j=0;j<n;++j)e.waves.push_back(reader.string());events.push_back(std::move(e));}
  for(unsigned i=0;i<np;++i){Placement p{};p.event=reader.read<unsigned>();p.origin=reader.read<Vec>();if(p.event>=events.size())throw std::runtime_error("Invalid placement event");placed.push_back(std::move(p));}
  for(unsigned i=0;i<nr;++i){Region r{};r.event=reader.read<unsigned>();r.origin=reader.read<Vec>();r.mins=reader.read<Vec>();r.maxs=reader.read<Vec>();unsigned n=reader.read<unsigned>();if(r.event>=events.size()||n>100000)throw std::runtime_error("Invalid trigger geometry");for(unsigned j=0;j<n;++j)r.triangles.push_back(reader.read<std::array<Vec,3>>());regions.push_back(std::move(r));}
  if(defaultEvent>=static_cast<int>(events.size()))throw std::runtime_error("Invalid default ambience");
  log("Loaded map="+map+" events="+std::to_string(events.size())+" emitters="+std::to_string(placed.size())+" regions="+std::to_string(regions.size()));
 }
 void update(){
  if(!master||events.empty())return;uint64_t now=GetTickCount64();if(now<nextUpdate)return;nextUpdate=now+60;
  DWORD owner=0;GetWindowThreadProcessId(GetForegroundWindow(),&owner);master->SetVolume(listenerTick&&now-listenerTick<1000&&owner==GetCurrentProcessId()?std::clamp(volume,0.f,1.f):0);
  if(!listenerTick)return;
  int selected=defaultEvent;float smallest=INFINITY;
  for(const auto& region:regions)if(contains(region,listener)){Vec span=sub(region.maxs,region.mins);float v=span.x*span.y*span.z;if(v<smallest){smallest=v;selected=region.event;}}
  if(selected!=currentEvent){ambience.reset();currentEvent=selected;if(selected>=0)ambience=create(events[selected]);log("Soundscape="+std::to_string(selected));}
  X3DAUDIO_LISTENER hear{};hear.Position=audioVec(listener);float pitch=angles.x*.0174532925f,yaw=angles.y*.0174532925f,roll=angles.z*.0174532925f;
  hear.OrientFront={std::cos(pitch)*std::cos(yaw),-std::sin(pitch),std::cos(pitch)*std::sin(yaw)};
  hear.OrientTop={std::cos(roll)*std::sin(pitch)*std::cos(yaw)+std::sin(roll)*std::sin(yaw),std::cos(roll)*std::cos(pitch),std::cos(roll)*std::sin(pitch)*std::sin(yaw)-std::sin(roll)*std::cos(yaw)};
  std::map<unsigned,std::vector<std::pair<float,size_t>>> nearest;
  for(size_t i=0;i<placed.size();++i){auto& p=placed[i];auto& e=events[p.event];float d=distance(listener,p.origin);if(e.radius<=0||d<=e.radius)nearest[p.event].emplace_back(d,i);else{p.voice.reset();p.played=false;}}
  for(auto& row:nearest){auto& e=events[row.first];std::sort(row.second.begin(),row.second.end());
   for(size_t i=0;i<row.second.size();++i){auto& p=placed[row.second[i].second];if(i>=e.limit){p.voice.reset();continue;}
    if(!p.voice&&(!p.played||e.loop)){p.voice=create(e);p.played=true;}
    if(!p.voice)continue;XAUDIO2_VOICE_STATE status{};p.voice->value->GetState(&status);if(!status.BuffersQueued){p.voice.reset();continue;}
    auto* format=reinterpret_cast<WAVEFORMATEX*>(p.voice->wave->format.data());
    if(format->nChannels==1&&!e.omni){X3DAUDIO_EMITTER emit{};emit.ChannelCount=1;emit.Position=audioVec(p.origin);emit.OrientFront={1,0,0};emit.OrientTop={0,1,0};emit.CurveDistanceScaler=std::max(1.f,e.radius);emit.DopplerScaler=0;
     X3DAUDIO_DISTANCE_CURVE_POINT points[]={{0,1},{1,0}};X3DAUDIO_DISTANCE_CURVE curve{points,2};emit.pVolumeCurve=&curve;
     std::vector<float> matrix(channels);X3DAUDIO_DSP_SETTINGS settings{};settings.SrcChannelCount=1;settings.DstChannelCount=channels;settings.pMatrixCoefficients=matrix.data();X3DAudioCalculate(spatial,&hear,&emit,X3DAUDIO_CALCULATE_MATRIX,&settings);p.voice->value->SetOutputMatrix(master,1,channels,matrix.data());
    }
   }
  }
 }
};
static Audio audio;
static const char*(*getString)(VM,long)=nullptr;static float(*getFloat)(VM,long)=nullptr;static float*(*getVector)(VM,long)=nullptr;
static int64_t(*registerFunction)(void*,Registration*,char)=nullptr;
static long startAudio(VM vm){try{const char* map=getString(vm,1);if(!map)throw std::runtime_error("Missing audio map argument");audio.start(map);}catch(const std::exception& e){audio.stop();log(std::string("Start failed: ")+e.what());}return 0;}
static long stopAudio(VM){audio.stop();return 0;}
static long listenerAudio(VM vm){float* p=getVector(vm,1);float* a=getVector(vm,2);if(p&&a){audio.listener={p[0],p[1],p[2]};audio.angles={a[0],a[1],a[2]};audio.volume=getFloat(vm,3);audio.listenerTick=GetTickCount64();}return 0;}
class Id:public PluginId{const char* GetString(int field)override{return field==0?"TF1 Map Audio Runtime":field==1?"TF1_AUDIO":"TF1AudioRuntime";}int64_t GetField(int field)override{return field==0?2:0x60c0ff;}};
class Callbacks:public PluginCallbacks {
 void bind(HMODULE module){if(registerFunction||!module)return;if(!clientHash(module)){log("Unsupported client.dll hash; refusing script ABI registration");return;}
  auto base=reinterpret_cast<unsigned char*>(module);getString=reinterpret_cast<decltype(getString)>(base+0x60c0);getFloat=reinterpret_cast<decltype(getFloat)>(base+0x6100);getVector=reinterpret_cast<decltype(getVector)>(base+0x6140);registerFunction=reinterpret_cast<decltype(registerFunction)>(base+0x108e0);log("Pinned retail client ABI verified");}
public:
 void Init(HMODULE,const PluginData* data,bool)override{wchar_t path[32768]{};GetModuleFileNameW(data->handle,path,32768);profile=fs::path(path).parent_path().parent_path();fs::create_directories(profile/"logs");log("Initialized plugin");bind(GetModuleHandleW(L"client.dll"));}
 void Finalize()override{bind(GetModuleHandleW(L"client.dll"));}
 bool Unload()override{audio.close();return true;}
 void OnSqvmCreated(void* vm)override{bind(GetModuleHandleW(L"client.dll"));if(!registerFunction||*reinterpret_cast<int*>(static_cast<unsigned char*>(vm)+0x3c)!=1)return;
  static Registration funcs[3]{};const char* names[]={"TF1Audio_Start","TF1Audio_Stop","TF1Audio_Listener"};const char* args[]={"string map","","vector position, vector angles, float volume"};long(*callbacks[])(VM)={startAudio,stopAudio,listenerAudio};
  for(int i=0;i<3;++i){auto& r=funcs[i];r.name=r.cpp=names[i];r.help="TF1 authored map audio adapter";r.returns="void";r.args=args[i];r.function=callbacks[i];registerFunction(vm,&r,1);}log("Registered CLIENT audio functions");}
 void OnSqvmDestroying(void* vm)override{if(*reinterpret_cast<int*>(static_cast<unsigned char*>(vm)+0x3c)==1)audio.stop();}
 void OnLibraryLoaded(HMODULE module,const char* name)override{if(name&&!_stricmp(name,"client.dll"))bind(module);}
 void RunFrame()override{try{audio.update();}catch(const std::exception& e){log(std::string("Playback stopped: ")+e.what());audio.stop();}}
};
static Id id;static Callbacks callbacks;
extern "C" __declspec(dllexport) void* CreateInterface(const char* name,int* status){void* p=!std::strcmp(name,"PluginId001")?static_cast<void*>(&id):!std::strcmp(name,"PluginCallbacks001")?static_cast<void*>(&callbacks):nullptr;if(status)*status=p?0:1;return p;}
extern "C" __declspec(dllexport) uint64_t TF1AudioRuntimeSamplesPlayed(){uint64_t total=0;XAUDIO2_VOICE_STATE state{};if(audio.ambience){audio.ambience->value->GetState(&state);total+=state.SamplesPlayed;}for(const auto& p:audio.placed)if(p.voice){p.voice->value->GetState(&state);total+=state.SamplesPlayed;}return total;}
extern "C" __declspec(dllexport) unsigned TF1AudioRuntimeVoiceCount(){unsigned count=audio.ambience?1:0;for(const auto& p:audio.placed)if(p.voice)++count;return count;}
