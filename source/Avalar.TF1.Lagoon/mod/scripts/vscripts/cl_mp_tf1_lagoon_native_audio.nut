global function TF1Port_mp_tf1_lagoon_NativeAudio_Init
global function TF1Port_mp_tf1_lagoon_NativeAudio_Shutdown
struct
{
 array<var> sounds
 array<bool> playing
 bool stopped = false
}
file
void function TF1Port_mp_tf1_lagoon_NativeAudio_Init()
{
 if (GetMapName() != "mp_tf1_lagoon") return
 file.stopped = false
 thread TF1Port_mp_tf1_lagoon_NativeAudio_Run()
}
void function TF1Port_mp_tf1_lagoon_NativeAudio_Shutdown()
{
 file.stopped = true
 foreach (int i, var sound in file.sounds)
  if (file.playing[i]) StopSound(sound)
 file.sounds.clear()
 file.playing.clear()
}
void function TF1Port_mp_tf1_lagoon_NativeAudio_Run()
{
 const int MAX_ACTIVE_SOUNDS = 32
 array<vector> positions = [Vector(-3233.99,923.73,37.0375),Vector(-6920,440,32),Vector(3073.31,2094.96,1610.44),Vector(2984.84,1917.88,591.062),Vector(2481.47,1964.36,548.675),Vector(3021.56,1996.61,1090.24),Vector(-722.225,9647.54,32.0083),Vector(-7374.58,7691.13,35.5505),Vector(-10535.8,3477.79,32.0009),Vector(-5100.91,-3811.29,33.8421),Vector(-3234.55,5683.32,31.9954),Vector(-6449.53,3983.99,33.4521),Vector(-621.13,3712.77,35.1911),Vector(-306.978,123.424,31.9964),Vector(-400.001,6553.46,50.3987),Vector(-9587.02,625.369,32.0076),Vector(-4845.42,-1195.29,32.0087),Vector(-9614.91,6320.95,81.1413),Vector(-4657.64,7808.47,31.9999),Vector(-3547.65,3277.62,31.9995),Vector(-6917.82,-2451.11,58.9125),Vector(-5263.85,2016.69,31.9996),Vector(-3412.31,-2756.77,31.9991),Vector(-8591.37,3806.32,32.2779),Vector(-6612.34,5970.72,32.7377),Vector(-7487.22,2205.9,31.9972),Vector(-2129.21,6967.2,31.9849),Vector(-3125.21,-730.276,153.791),Vector(-1667.56,5183.68,32.0006),Vector(-4871.86,4230.13,31.996),Vector(-9193.64,2387.83,32.0005),Vector(-959.121,8146.31,32.0008)]
 array<string> events = ["Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum","Coliseum_Emit_DomePanel_Hum"]
 array<float> radii = [700.0,500.0,2000.0,1500.0,1500.0,1250.0,700.0,500.0,700.0,500.0,500.0,500.0,500.0,500.0,500.0,700.0,700.0,500.0,700.0,500.0,500.0,500.0,500.0,500.0,500.0,500.0,700.0,500.0,500.0,500.0,500.0,500.0]
 array<float> durations = [45.97151,36.83516,12.32906,19.10816,32.0544,4.195683,45.97151,36.83516,45.97151,36.83516,36.83516,36.83516,36.83516,36.83516,36.83516,45.97151,45.97151,36.83516,45.97151,36.83516,36.83516,36.83516,36.83516,36.83516,36.83516,36.83516,45.97151,36.83516,36.83516,36.83516,36.83516,36.83516]
 array<float> retryAfter
 int activeCount = 0
 foreach (vector position in positions)
 {
  file.sounds.append(null)
  file.playing.append(false)
  retryAfter.append(0.0)
 }
 printt("TF1_NATIVE_AUDIO_READY", GetMapName(), positions.len())
 while (!file.stopped)
 {
  entity player = GetLocalClientPlayer()
  bool active = IsValid(player) && IsAlive(player) && GetGameState() == eGameState.Playing
  foreach (int i, vector position in positions)
  {
   // Begin outside the authored radius so the native spatial curve can fade
   // in; use hysteresis and bounded retries for inaudible culled voices.
   bool wanted = active
   if (wanted) wanted = Distance(player.EyePosition(),position) < radii[i] + (file.playing[i] ? 2048.0 : 1024.0)
   if (!wanted && file.playing[i])
   {
    StopSound(file.sounds[i])
    file.playing[i] = false
   activeCount--
   }
   if (wanted && !file.playing[i] && activeCount < MAX_ACTIVE_SOUNDS && Time() >= retryAfter[i])
   {
    // Bound replicated long loops so a dense shoreline cannot exhaust the
    // net channel. The native spatial curve still handles distance fading.
    file.sounds[i] = EmitSoundAtPosition(player.GetTeam(), position, events[i])
    file.playing[i] = true
    activeCount++
    retryAfter[i] = Time() + durations[i]
    printt("TF1_NATIVE_AUDIO_START", i, events[i])
   }
  }
  wait 0.1
 }
}
