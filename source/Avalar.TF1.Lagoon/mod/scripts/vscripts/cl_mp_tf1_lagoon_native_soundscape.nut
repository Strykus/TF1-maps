global function TF1Port_mp_tf1_lagoon_NativeSoundscape_Init
global function TF1Port_mp_tf1_lagoon_NativeSoundscape_Shutdown
struct
{
 bool stopped = false
 var sound = null
 float retryAt = 0.0
}
file
void function TF1Port_mp_tf1_lagoon_NativeSoundscape_Init()
{
 if (GetMapName() != "mp_tf1_lagoon") return
 file.stopped = false
 thread TF1Port_mp_tf1_lagoon_NativeSoundscape_Run()
}
void function TF1Port_mp_tf1_lagoon_NativeSoundscape_Shutdown()
{
 file.stopped = true
 if (file.sound != null) StopSound(file.sound)
 file.sound = null
}
void function TF1Port_mp_tf1_lagoon_NativeSoundscape_Run()
{
 printt("TF1_NATIVE_SOUNDSCAPE_READY", GetMapName(), 4, 4)
 while (!file.stopped)
 {
  entity player = GetLocalClientPlayer()
  bool active = IsValid(player) && IsAlive(player) && GetGameState() == eGameState.Playing
  if (!active)
  {
   if (file.sound != null) StopSound(file.sound)
   file.sound = null
  }
  else if (file.sound == null && Time() >= file.retryAt)
  {
   file.sound = EmitSoundAtPosition(player.GetTeam(), player.EyePosition(), "Coliseum_Emit_DigitalForest")
   file.retryAt = Time() + 171.0065
   printt("TF1_NATIVE_SOUNDSCAPE_START", 0, "Coliseum_Emit_DigitalForest")
  }
  wait 0.25
 }
}
