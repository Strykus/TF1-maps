global function TF1Port_mp_tf1_nexus_AudioInit
global function TF1Port_mp_tf1_nexus_AudioShutdown

void function TF1Port_mp_tf1_nexus_AudioInit()
{
#if TF1AudioRuntime
 if ( GetMapName() != "mp_tf1_nexus" )
  return
 TF1Audio_Start( GetMapName() )
 thread TF1Port_mp_tf1_nexus_AudioThread()
#endif
}

void function TF1Port_mp_tf1_nexus_AudioShutdown()
{
#if TF1AudioRuntime
 TF1Audio_Stop()
#endif
}

#if TF1AudioRuntime
void function TF1Port_mp_tf1_nexus_AudioThread()
{
 while ( true )
 {
  entity player = GetLocalViewPlayer()
  if ( IsValid( player ) )
   TF1Audio_Listener( player.EyePosition(), player.EyeAngles(), GetConVarFloat( "sound_volume" ) )
  wait 0.067
 }
}
#endif

