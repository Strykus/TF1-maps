global function TF1SwampAmbient_ServerPrecache
global function TF1SwampAmbient_ServerInit

const asset TF1_SWAMP_FLYER = $"models/creatures/flyer/flyer_a.mdl"

struct SwampPerch
{
	vector origin
	vector angles
	bool start = false
	bool initialOnly = false
	entity flyer
	bool startled = false
	float health = 1500.0
	bool feed = false
}

struct
{
	array<SwampPerch> perches
	bool pulseImminent = false
	bool spawned = false
	bool animationsValidated = false
} file

void function TF1SwampAmbient_ServerPrecache()
{
	if ( GetMapName() != "mp_tf1_swampland" )
		return
	foreach ( model in [
		$"models/imc_base/radar_a.mdl", $"models/imc_base/radar_b.mdl",
		$"models/imc_base/radar_c.mdl", $"models/imc_base/radar_d.mdl",
		$"models/imc_base/radar_e.mdl", $"models/imc_base/radar_f.mdl",
		$"models/imc_base/radar_g.mdl", $"models/imc_base/radar_h.mdl",
		$"models/imc_base/radar_i.mdl"
	] )
		PrecacheModel( model )
	PrecacheModel( TF1_SWAMP_FLYER )
	PrecacheModel( $"models/creatures/flyer/flyer_anims.mdl" )
}

void function TF1SwampAmbient_ServerInit()
{
	if ( GetMapName() != "mp_tf1_swampland" )
		return
	AddDamageCallback( "script_mover", TF1SwampAmbient_OnDamage )
	AddCallback_EntitiesDidLoad( TF1SwampAmbient_ServerSpawn )
}

void function TF1SwampAmbient_AddPerch( vector origin, float yaw, bool start = false, bool initialOnly = false )
{
	SwampPerch perch
	perch.origin = origin
	perch.angles = <0, yaw, 0>
	perch.start = start
	perch.initialOnly = initialOnly
	file.perches.append( perch )
}

void function TF1SwampAmbient_ServerSpawn()
{
	if ( file.spawned )
		return
	file.spawned = true
	entity tower = GetEnt( "prop_airbase_tower" )
	if ( !IsValid( tower ) )
		throw "Swampland tower entity missing"
	tower.kv.targetname = "prop_airbase_tower_main"
	tower.Anim_Play( "worker_base_whistle_tower_idle_new" )
	printt( "TF1_SWAMP_TOWER_ANIMATING", tower.GetSequenceDuration( "worker_base_whistle_tower_idle_new" ) )

	TF1SwampAmbient_AddPerch( < -1437.2, -5829.2, 58.0 >, 90 )
	TF1SwampAmbient_AddPerch( < -3934.4, -5505.2, 904.0 >, 60, true )
	TF1SwampAmbient_AddPerch( < -1767.5, -4761.1, 430.9 >, 157 )
	TF1SwampAmbient_AddPerch( < -3600.6, -2949.1, 275.1 >, -53 )
	TF1SwampAmbient_AddPerch( < -5229.9, -780.4, 1455.0 >, -137, true )
	TF1SwampAmbient_AddPerch( < -8187.9, -923.7, 1765.4 >, 83 )
	TF1SwampAmbient_AddPerch( < -7561.2, -808.8, 1584.6 >, 45, true )
	TF1SwampAmbient_AddPerch( < -8239.7, 288.4, 1122.4 >, -48 )
	TF1SwampAmbient_AddPerch( < -1896.7, 5080.8, 1369.5 >, 101, true )
	TF1SwampAmbient_AddPerch( < -2045.5, -7055.4, 263.0 >, -108 )
	TF1SwampAmbient_AddPerch( < -6010.7, -4648.3, 525.5 >, 27 )
	TF1SwampAmbient_AddPerch( < -4098.0, -3745.1, 320.4 >, -70, true )
	TF1SwampAmbient_AddPerch( < -2546.1, -5656.9, 61.0 >, 111 )
	TF1SwampAmbient_AddPerch( < -3892.2, -6333.4, 126.2 >, 19 )
	TF1SwampAmbient_AddPerch( < -2796.8, -3788.1, 253.2 >, -156, true )
	TF1SwampAmbient_AddPerch( < -760.4, -5628.4, 592.7 >, -178 )
	TF1SwampAmbient_AddPerch( < -1665.1, -4035.2, 430.9 >, -23 )
	TF1SwampAmbient_AddPerch( < -5857.9, -925.2, 329.5 >, 144 )
	TF1SwampAmbient_AddPerch( < -4412.4, -1271.4, 457.3 >, -91 )
	TF1SwampAmbient_AddPerch( < -4791.8, -2518.4, 249.4 >, 114 )
	TF1SwampAmbient_AddPerch( < -4732.0, 278.2, 662.1 >, -136, true, true )
	TF1SwampAmbient_AddPerch( < -2403.6, -2653.3, 588.2 >, -179, true, true )
	TF1SwampAmbient_AddPerch( < -1893.2, -2435.0, 486.0 >, -90, true, true )
	TF1SwampAmbient_AddPerch( < -790.3, -2188.6, 488.0 >, -112, true, true )
	TF1SwampAmbient_AddPerch( < -3870.2, -4019.1, 109.6 >, 24, true, true )
	TF1SwampAmbient_AddPerch( < -3489.4, 672.4, 478.5 >, -167, true, true )
	TF1SwampAmbient_AddPerch( < -4071.5, 1608.8, 964.0 >, -148, true, true )
	TF1SwampAmbient_AddPerch( < -6791.3, 445.6, 1215.8 >, -95, true, true )
	TF1SwampAmbient_AddPerch( < -2750.2, 2735.7, 1362.3 >, -129, true, true )
	TF1SwampAmbient_AddPerch( < -782.1, 1065.9, 442.0 >, -1, true, true )
	TF1SwampAmbient_AddPerch( < -1284.3, 2388.1, 269.8 >, -125, true, true )
	thread TF1SwampAmbient_Populate()
	thread TF1SwampAmbient_Pulse( tower )
}

bool function TF1SwampAmbient_PlayerNear( vector origin, float distance )
{
	foreach ( player in GetPlayerArray() )
	{
		if ( IsAlive( player ) && DistanceSqr( player.GetOrigin(), origin ) < distance * distance )
			return true
	}
	return false
}

void function TF1SwampAmbient_Populate()
{
	foreach ( perch in file.perches )
	{
		if ( perch.start )
		{
			TF1SwampAmbient_CreateFlyer( perch, !perch.initialOnly )
			WaitEndFrame()
		}
	}
	int initialCount = 0
	foreach ( perch in file.perches )
	{
		if ( IsValid( perch.flyer ) )
			initialCount++
	}
	printt( "TF1_SWAMP_FLYERS_READY", initialCount, file.perches.len() )
	while ( true )
	{
		wait 5.0
		if ( file.pulseImminent )
			continue
		array<SwampPerch> vacant
		int occupied = 0
		foreach ( perch in file.perches )
		{
			if ( IsValid( perch.flyer ) )
				occupied++
			else if ( !perch.initialOnly && !TF1SwampAmbient_PlayerNear( perch.origin, 768.0 ) )
				vacant.append( perch )
		}
		while ( occupied < 10 && vacant.len() > 0 && !file.pulseImminent )
		{
			int index = RandomInt( vacant.len() )
			SwampPerch perch = vacant[index]
			vacant.remove( index )
			if ( TF1SwampAmbient_PlayerNear( perch.origin, 768.0 ) )
				continue
			TF1SwampAmbient_CreateFlyer( perch, true )
			occupied++
			wait RandomFloatRange( 0.1, 5.0 )
		}
	}
}

void function TF1SwampAmbient_CreateFlyer( SwampPerch perch, bool land )
{
	if ( IsValid( perch.flyer ) )
		throw "Swampland attempted duplicate flyer spawn"
	entity flyer = CreateEntity( "script_mover" )
	flyer.kv.SpawnAsPhysicsMover = false
	flyer.SetValueForModelKey( TF1_SWAMP_FLYER )
	flyer.kv.solid = 8
	flyer.kv.DisableBoneFollowers = 1
	flyer.kv.fadedist = 7000
	DispatchSpawn( flyer )
	flyer.SetOrigin( perch.origin )
	flyer.SetAngles( perch.angles )
	flyer.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
	if ( !file.animationsValidated )
	{
		foreach ( animation in ["land_flat", "flyer_perched_idle", "flyer_perched_idlelook", "flyer_perched_scream",
		                       "flyer_perched_takeoff", "flyer_perched_feed", "flyer_perched_takeoff_attacked", "flyer_perched_death", "flyer_dropshipattack_right", "flyer_dropshipattack_top", "flyer_dropshipattack_cockpit", "flyer_dropshipattack_vertical_top", "flyer_dropshipattack_vertical_cockpit", "flyer_dropshipattack_vertical_right"] )
		{
			float duration = flyer.GetSequenceDuration( animation )
			if ( duration <= 0.04 )
				throw "Swampland flyer animation missing: " + animation
			printt( "TF1_SWAMP_FLYER_SEQUENCE", animation, duration )
		}
		file.animationsValidated = true
	}
	perch.flyer = flyer
	perch.startled = false
	perch.health = 1500.0
	TraceResults ground = TraceLine( perch.origin + <0, 0, 32>, perch.origin - <0, 0, 32>, flyer, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
	perch.feed = ground.surfaceName == "flesh"
	thread TF1SwampAmbient_FlyerThink( perch, flyer, land )
}

void function TF1SwampAmbient_OnDamage( entity flyer, var damageInfo )
{
	foreach ( perch in file.perches )
	{
		if ( perch.flyer != flyer )
			continue
		perch.startled = true
		perch.health -= DamageInfo_GetDamage( damageInfo )
		return
	}
}

void function TF1SwampAmbient_FlyerThink( SwampPerch perch, entity flyer, bool land )
{
	flyer.EndSignal( "OnDestroy" )
	OnThreadEnd(
		function() : ( flyer )
		{
			if ( IsValid( flyer ) )
				flyer.Destroy()
		}
	)
	float nextIdle = 0.0
	if ( land )
	{
		flyer.Anim_PlayWithRefPoint( "land_flat", perch.origin, perch.angles, 0.0 )
		wait flyer.GetSequenceDuration( "land_flat" )
	}
	while ( true )
	{
		bool fast = perch.startled || TF1SwampAmbient_PlayerNear( perch.origin, 512.0 )
		if ( fast || TF1SwampAmbient_PlayerNear( perch.origin, 1024.0 ) )
		{
			string animation = fast ? "flyer_perched_takeoff_attacked" : "flyer_perched_takeoff"
			if ( perch.health <= 0.0 )
				animation = "flyer_perched_death"
			flyer.Anim_PlayWithRefPoint( animation, perch.origin, perch.angles, 1.0 )
			printt( "TF1_SWAMP_FLYER_DEPARTING", animation, perch.origin )
			wait flyer.GetSequenceDuration( animation )
			return
		}
		if ( Time() >= nextIdle )
		{
			int roll = RandomInt( perch.feed ? 11 : 8 )
			string idle = "flyer_perched_idle"
			if ( nextIdle > 0.0 )
				idle = roll < 5 ? "flyer_perched_idle" : (roll < 7 ? "flyer_perched_idlelook" : (roll < 8 ? "flyer_perched_scream" : "flyer_perched_feed"))
			flyer.Anim_PlayWithRefPoint( idle, perch.origin, perch.angles, 1.0 )
			nextIdle = Time() + flyer.GetSequenceDuration( idle )
		}
		wait 0.25
	}
}

void function TF1SwampAmbient_Pulse( entity tower )
{
	tower.EndSignal( "OnDestroy" )
	while ( true )
	{
		wait 35.0
		file.pulseImminent = true
		TF1SwampScenes_TowerPulse( tower )
		foreach ( perch in file.perches )
		{
			if ( IsValid( perch.flyer ) )
				thread TF1SwampAmbient_Scare( perch )
		}
		wait 3.0
		TF1SwampScenes_TowerPulse( tower )
		wait 5.0
		file.pulseImminent = false
	}
}

void function TF1SwampAmbient_Scare( SwampPerch perch )
{
	entity flyer = perch.flyer
	flyer.EndSignal( "OnDestroy" )
	wait RandomFloatRange( 0.0, 1.5 )
	perch.startled = true
}
