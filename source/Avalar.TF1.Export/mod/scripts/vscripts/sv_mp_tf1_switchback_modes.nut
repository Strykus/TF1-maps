global function TF1Port_mp_tf1_switchback_Modes_Init

// The map data names the flag spawns the other way round from the team start spawns
// (the IMC flag sat in the Militia start area), so Capture the Flag is mirrored here.
// Flag spawns and the Speedball flag are also put on the floor the players walk on:
// the flag is a physics item, and over empty air it falls away from its base and icon.
const string TF1_EXPORT_SWITCHBACK = "mp_tf1_switchback"

void function TF1Port_mp_tf1_switchback_Modes_Init()
{
	if ( GetMapName() != TF1_EXPORT_SWITCHBACK )
		return

	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_switchback_Modes_OnEntitiesLoaded )
}

void function TF1Port_mp_tf1_switchback_Modes_OnEntitiesLoaded()
{
	string mode = GameRules_GetGameMode()

	if ( mode == "ctf" || mode == "ctf_comp" )
	{
		TF1Port_mp_tf1_switchback_Modes_PrepareCTFFlags()
	}
	else if ( mode == "speedball" )
		TF1Port_mp_tf1_switchback_Modes_MoveSpeedballFlag()
}

// CTF creates (and at every round start recreates) the base platforms and flags itself, so
// this watcher checks them once a second. The platform model does not have its origin on its
// bottom face: it is measured, its bottom face is put on the floor, and the flag goes on top.
void function TF1Port_mp_tf1_switchback_Modes_WatchCTFBases()
{
	array<entity> done

	while ( true )
	{
		wait 1.0

		foreach ( string suffix in [ "imc", "mil" ] )
		{
			entity base = GetGlobalNetEnt( suffix + "FlagHome" )
			if ( !IsValid( base ) || done.contains( base ) )
				continue

			done.append( base )
			entity flag = GetGlobalNetEnt( suffix + "Flag" )
			TF1Port_mp_tf1_switchback_Modes_SeatBaseOnFloor( suffix, base, flag )
		}
	}
}

void function TF1Port_mp_tf1_switchback_Modes_SeatBaseOnFloor( string suffix, entity base, entity flag )
{
	vector origin = base.GetOrigin()
	vector mins = base.GetBoundingMins()
	vector maxs = base.GetBoundingMaxs()
	TraceResults floor = TraceLine( origin + < 0, 0, 48 >, origin - < 0, 0, 400 >, base, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
	if ( floor.startSolid || floor.fraction >= 1.0 )
	{
		printt( "TF1_EXPORT_MODES ctf base", suffix, origin, "mins", mins, "maxs", maxs, "no floor found" )
		return
	}

	float wantedZ = floor.endPos.z - mins.z
	printt( "TF1_EXPORT_MODES ctf base", suffix, origin, "mins", mins, "maxs", maxs, "floor", floor.endPos.z, "-> origin z", wantedZ )
	base.SetOrigin( < origin.x, origin.y, wantedZ > )

	if ( IsValid( flag ) && flag.GetParent() == null )
	{
		flag.SetOrigin( base.GetOrigin() + < 0, 0, maxs.z + 1 > )
		flag.SetVelocity( < 0, 0, 1 > )
	}
}

// CTF reads the team and origin of every info_spawnpoint_flag when the prematch starts,
// which is after this callback.
void function TF1Port_mp_tf1_switchback_Modes_PrepareCTFFlags()
{
	foreach ( entity spawn in GetEntArrayByClass_Expensive( "info_spawnpoint_flag" ) )
	{
		int team = spawn.GetTeam()
		if ( team == TEAM_IMC || team == TEAM_MILITIA )
			SetTeam( spawn, GetOtherTeam( team ) )

		vector origin = spawn.GetOrigin()
		vector floorPos = TF1Port_mp_tf1_switchback_Modes_FindFloor( origin )

		// the original base point (1276, -656) lies on the sloped side of the bridge, so the
		// physics flag slides off it and ends up under the bridge; the base goes to the flat
		// floor spot the author chose (player origin, so it is exactly on the floor)
		if ( Distance( < origin.x, origin.y, 0 >, < 1276.0, -656.0, 0 > ) < 200.0 )
			floorPos = < 1723.07, -475.87, 381.37 >

		printt( "TF1_EXPORT_MODES ctf flag spawn", origin, "team", team, "->", spawn.GetTeam(), "floor", floorPos )
		spawn.SetOrigin( floorPos )
	}
}

// Without an info_speedball_flag Speedball creates its flag on hardpoint group B. The base
// is created at the hardpoint origin and the flag falls to the floor, so the origin has to
// be on the floor or the base platform hangs above the flag.
void function TF1Port_mp_tf1_switchback_Modes_MoveSpeedballFlag()
{
	foreach ( entity hardpoint in GetEntArrayByClass_Expensive( "info_hardpoint" ) )
	{
		if ( !hardpoint.HasKey( "hardpointGroup" ) || string( hardpoint.kv.hardpointGroup ) != "B" )
			continue

		vector target = < 625.9, -659.0, 347.0 >
		vector floorPos = TF1Port_mp_tf1_switchback_Modes_FindFloor( target )
		printt( "TF1_EXPORT_MODES speedball flag", hardpoint.GetOrigin(), "->", target, "floor", floorPos )
		hardpoint.SetOrigin( floorPos )
		return
	}

	printt( "TF1_EXPORT_MODES speedball flag: hardpoint B not found" )
}

// First surface a player can stand on below the point; the search starts above the point
// so a point that is inside geometry still finds the surface over it.
vector function TF1Port_mp_tf1_switchback_Modes_FindFloor( vector origin )
{
	foreach ( float lift in [ 16.0, 96.0, 256.0 ] )
	{
		TraceResults floor = TraceLine( origin + < 0, 0, lift >, origin - < 0, 0, 700 >, null, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
		if ( floor.startSolid || floor.fraction >= 1.0 )
			continue

		return floor.endPos
	}

	return origin
}
