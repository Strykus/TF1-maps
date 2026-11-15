global function TF1Export_CTFFlags_Init

// TF1 ports ship no info_spawnpoint_flag entities, so CTF would have no flag bases.
// Create one per team at the walkable human start spawn closest to that team's start-spawn centroid.
void function TF1Export_CTFFlags_Init()
{
	printt( "TF1Export CTF init: mode", GameRules_GetGameMode(), "map", GetMapName() )

	if ( GameRules_GetGameMode() != "ctf" )
		return

	if ( GetMapName() != "mp_tf1_switchback" )
		return

	AddCallback_EntitiesDidLoad( TF1Export_CreateCTFFlagSpawns )
}

void function TF1Export_CreateCTFFlagSpawns()
{
	printt( "TF1Export CTF: entities loaded callback" )

	array<entity> existingFlags = GetEntArrayByClass_Expensive( "info_spawnpoint_flag" )
	printt( "TF1Export CTF: existing info_spawnpoint_flag count", existingFlags.len() )
	foreach ( entity existing in existingFlags )
		printt( "TF1Export CTF: existing flag spawn team", existing.GetTeam(), "at", existing.GetOrigin() )

	if ( existingFlags.len() > 0 )
		return

	array<entity> allStarts = GetEntArrayByClass_Expensive( "info_spawnpoint_human_start" )

	foreach ( int team in [ TEAM_IMC, TEAM_MILITIA ] )
	{
		array<entity> starts
		foreach ( entity spawn in allStarts )
		{
			if ( spawn.GetTeam() == team )
				starts.append( spawn )
		}

		if ( starts.len() == 0 )
		{
			printt( "TF1Export CTF: no human start spawns for team", team, "- no flag created" )
			continue
		}

		vector centroid = < 0, 0, 0 >
		foreach ( entity spawn in starts )
			centroid += spawn.GetOrigin()
		centroid = centroid * ( 1.0 / starts.len() )

		entity best = starts[ 0 ]
		foreach ( entity spawn in starts )
		{
			if ( Distance( spawn.GetOrigin(), centroid ) < Distance( best.GetOrigin(), centroid ) )
				best = spawn
		}

		entity flagSpawn = CreateEntity( "info_spawnpoint_flag" )
		flagSpawn.SetOrigin( best.GetOrigin() )
		flagSpawn.SetAngles( best.GetAngles() )
		SetTeam( flagSpawn, team )
		DispatchSpawn( flagSpawn )
		printt( "TF1Export CTF: flag spawn for team", team, "at", best.GetOrigin() )
	}
}
