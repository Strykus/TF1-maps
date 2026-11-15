global function TF1Outpost_CTFFlagsInit

void function TF1Outpost_CTFFlagsInit()
{
 if ( GetMapName() != "mp_tf1_outpost_207" || GameRules_GetGameMode() != "ctf" ) return
 AddCallback_EntitiesDidLoad( TF1Outpost_CreateCTFFlagSpawns )
}

void function TF1Outpost_CreateCTFFlagSpawns()
{
 array<entity> flags = GetEntArrayByClass_Expensive( "info_spawnpoint_flag" )
 array<entity> allStarts = GetEntArrayByClass_Expensive( "info_spawnpoint_human_start" )
 foreach ( int team in [ TEAM_IMC, TEAM_MILITIA ] )
 {
  bool present = false
  foreach ( entity flag in flags )
   if ( flag.GetTeam() == team ) present = true
  if ( present ) continue
  array<entity> starts
  foreach ( entity spawn in allStarts )
  {
   if ( spawn.GetTeam() != team ) continue
   if ( spawn.HasKey( "gamemode_ctf" ) && spawn.kv.gamemode_ctf == "0" ) continue
   starts.append( spawn )
  }
  Assert( starts.len() > 0, "Outpost CTF has no start spawn for a team" )
  vector centroid = < 0, 0, 0 >
  foreach ( entity spawn in starts ) centroid += spawn.GetOrigin()
  centroid = centroid * ( 1.0 / starts.len() )
  entity best = starts[0]
  foreach ( entity spawn in starts )
   if ( Distance( spawn.GetOrigin(), centroid ) < Distance( best.GetOrigin(), centroid ) ) best = spawn
  entity flagSpawn = CreateEntity( "info_spawnpoint_flag" )
  flagSpawn.SetOrigin( best.GetOrigin() )
  flagSpawn.SetAngles( best.GetAngles() )
  SetTeam( flagSpawn, team )
  DispatchSpawn( flagSpawn )
  printt( "TF1_OUTPOST_CTF_FLAG", team, best.GetOrigin() )
 }
}
