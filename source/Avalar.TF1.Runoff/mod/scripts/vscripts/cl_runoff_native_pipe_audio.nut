global function RunoffNativePipeAudio_Precache
global function RunoffNativePipeAudio_Init
global function RunoffNativePipeAudio_Shutdown
const string RUNOFF_NATIVE_PIPE_EVENT = "Coliseum_Emit_DomePanel_Hum"
struct
{
 array<var> sounds
 array<bool> playing
 bool stopped = false
}
file
void function RunoffNativePipeAudio_Precache() {}
void function RunoffNativePipeAudio_Init()
{
 if (GetMapName() != "mp_tf1_runoff") return
 thread RunoffNativePipeAudio_Run()
}
void function RunoffNativePipeAudio_Shutdown()
{
 file.stopped = true
 foreach (int i, var sound in file.sounds)
 {
  if (file.playing[i]) StopSound(sound)
 }
 file.sounds.clear()
 file.playing.clear()
}
void function RunoffNativePipeAudio_Run()
{
 array<vector> positions = [< -2256,-1226,340.5>,< -2256,-858,340.5>,<388,-1820,112>,<375.717,-362.266,643.628>,<438.955,-361.556,317.095>,<476.271,-402.222,116.708>]
 foreach (vector position in positions)
 {
  file.sounds.append(null)
  file.playing.append(false)
 }
 printt("RUNOFF_PIPE_POSITION_READY",positions.len())
 while (!file.stopped)
 {
  entity player = GetLocalClientPlayer()
  foreach (int i, vector position in positions)
  {
   bool wanted = false
   if (IsValid(player) && IsAlive(player) && GetGameState() == eGameState.Playing)
   {
    float radius = i < 2 ? 2100.0 : 600.0
    wanted = Distance(player.EyePosition(),position) < radius && (i >= 3 || RunoffTubeAudio_IsPumpRunning())
   }
   if (file.playing[i] && !IsSoundStillPlaying(file.sounds[i])) file.playing[i] = false
   if (!wanted && file.playing[i])
   {
    StopSound(file.sounds[i])
    file.playing[i] = false
    printt("RUNOFF_PIPE_POSITION_STOP",i)
   }
   if (wanted && !file.playing[i])
   {
    string eventName = i < 2 ? "Coliseum_Emit_DigitalForest" : RUNOFF_NATIVE_PIPE_EVENT
    file.sounds[i] = EmitSoundAtPosition(player.GetTeam(),position,eventName)
    file.playing[i] = true
    printt("RUNOFF_PIPE_POSITION_START",i)
   }
  }
  wait 0.1
 }
}

