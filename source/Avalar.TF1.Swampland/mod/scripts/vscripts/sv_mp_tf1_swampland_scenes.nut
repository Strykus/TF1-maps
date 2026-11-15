global function TF1SwampScenes_Precache
global function TF1SwampScenes_Init
global function TF1SwampScenes_TowerPulse
global function TF1SwampScenes_AttackDropship

const asset TF1_SWAMP_LEVIATHAN = $"models/creatures/leviathan/leviathan_swampland_small.mdl"
const asset TF1_SWAMP_ATTACK_FLYER = $"models/creatures/flyer/flyer_a.mdl"
const asset TF1_SWAMP_PULSE = $"mp_tf1_swampland_P_dog_w_pulse_st_idle"
const asset TF1_SWAMP_BIRDS = $"mp_tf1_swampland_eject_bird_burst_omni"

struct SwampSceneNode
{
	string name
	vector origin
	vector angles
	bool roar = false
	array<int> children
}

struct SwampLeviathanState
{
	entity prop
	int generation = 0
	int animation = -1
	float started
	vector origin
	vector angles
}

struct
{
	array<SwampSceneNode> nodes
	array<SwampLeviathanState> leviathans
	int attackCount = 0
	bool spawned = false
} file

void function TF1SwampScenes_Precache()
{
	if ( GetMapName() != "mp_tf1_swampland" )
		return
	PrecacheModel( TF1_SWAMP_LEVIATHAN )
	PrecacheParticleSystem( TF1_SWAMP_PULSE )
	PrecacheParticleSystem( TF1_SWAMP_BIRDS )
	PrecacheModel( $"models/fx/energy_hld_01.mdl" )
}

void function TF1SwampScenes_Init()
{
	if ( GetMapName() != "mp_tf1_swampland" )
		return
	AddCallback_EntitiesDidLoad( TF1SwampScenes_Spawn )
	AddCallback_OnClientConnected( TF1SwampScenes_SyncPlayer )
}

void function TF1SwampScenes_AddNode( string name, vector origin, vector angles, bool roar, array<int> children )
{
	SwampSceneNode node
	node.name = name
	node.origin = origin
	node.angles = angles
	node.roar = roar
	node.children = children
	file.nodes.append( node )
}

void function TF1SwampScenes_Spawn()
{
	if ( file.spawned )
		return
	file.spawned = true
	TF1SwampScenes_AddNode( "cinematic_mp_node_us0", < -8229.49, 9206.27, -8960.19 >, < 0, -56, 0 >, false, [3] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us4", < -8186.66, 9239.51, -8960.26 >, < 0, -76, 0 >, false, [15, 19] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us23", < -8188.07, 9202.21, -8960.24 >, < 0, 66.6669, 0 >, false, [24] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us5", < -8221.2, 9206.6, -8960.21 >, < 0, -36, 0 >, false, [4, 8] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us6", < -8206.39, 9203.68, -8960.47 >, < 0, 0, 0 >, false, [5] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us1", < -8205.31, 9215.06, -8960.06 >, < 0, 0, 0 >, true, [6] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us2", < -8203.32, 9226.33, -8960.16 >, < 0, 0, 0 >, false, [7] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us3", < -8185.89, 9247.41, -8960.3 >, < 0, 0, 0 >, false, [] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us12", < -8208.55, 9206.77, -8960.98 >, < 0, 0, 0 >, true, [9] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us13", < -8204.81, 9213.24, -8960.15 >, < 0, 0, 0 >, false, [10] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us14", < -8204.41, 9220.58, -8960.19 >, < 0, 0, 0 >, true, [11] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us15", < -8204.02, 9224.09, -8960.23 >, < 0, 0, 0 >, false, [12] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us20", < -8198, 9234.07, -8960.2 >, < 0, 0, 0 >, false, [13] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us21", < -8199.92, 9238.16, -8960.36 >, < 0, 0, 0 >, false, [14] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us22", < -8218.92, 9248.95, -8959.87 >, < 0, 0, 0 >, false, [] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us7", < -8184.82, 9214.24, -8959.83 >, < 0, 0, 0 >, true, [16] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us8", < -8173.85, 9212.8, -8959.8 >, < 0, 0, 0 >, false, [17] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us9", < -8149.89, 9222.53, -8959.19 >, < 0, 0, 0 >, false, [18] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us19", < -8150.46, 9234.78, -8960.07 >, < 0, 0, 0 >, false, [] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us10", < -8185.46, 9225.21, -8960.1 >, < 0, 0, 0 >, true, [20] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us11", < -8186.51, 9221.9, -8960.13 >, < 0, 0, 0 >, false, [21] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us16", < -8186.05, 9218.75, -8959.91 >, < 0, 0, 0 >, true, [22] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us17", < -8150.5, 9218.87, -8959.91 >, < 0, 0, 0 >, false, [23] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us18", < -8151.45, 9232.91, -8959.86 >, < 0, 0, 0 >, false, [] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us25", < -8186.83, 9205.01, -8960.23 >, < 0, 0, 0 >, true, [25] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us26", < -8182.97, 9213.96, -8960.04 >, < 0, 0, 0 >, false, [26] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us24", < -8174.45, 9227.53, -8959.81 >, < 0, 0, 0 >, false, [27] )
	TF1SwampScenes_AddNode( "cinematic_mp_node_us27", < -8188.66, 9241.25, -8960.22 >, < 0, 0, 0 >, false, [] )
	for ( int i = 0; i < 3; i++ )
	{
		SwampLeviathanState state
		file.leviathans.append( state )
	}
	thread TF1SwampScenes_Leviathan( 0, 2, false, false, 0.0 )
	thread TF1SwampScenes_Leviathan( 1, 0, true, true, 0.0 )
	thread TF1SwampScenes_Leviathan( 2, 1, false, true, 75.0 )
	entity birdTrigger = GetEnt( "BirdScareTrigger" )
	if ( !IsValid( birdTrigger ) )
		throw "Swampland bird scare trigger missing"
	birdTrigger.ConnectOutput( "OnStartTouch", TF1SwampScenes_BirdTouch )
	thread TF1SwampScenes_AttackSchedule()
	printt( "TF1_SWAMP_SCENES_READY", file.nodes.len() )
}

void function TF1SwampScenes_TowerPulse( entity tower )
{
	entity pulse = PlayFX( TF1_SWAMP_PULSE, tower.GetOrigin() + <0, 0, 13365> )
	pulse.FXEnableRenderAlways()
	pulse.DisableHibernation()
	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_TF1SwampPulse" )
	printt( "TF1_SWAMP_TOWER_PULSE", Time() )
}

void function TF1SwampScenes_BirdTouch( entity trigger, entity player, entity caller, var value )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	float delay = player.GetVelocity().z / 750.0 - sqrt( 500.0 / 750.0 )
	if ( delay >= 0.0 )
		thread TF1SwampScenes_Birds( player, delay )
}

void function TF1SwampScenes_Birds( entity player, float delay )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )
	wait delay
	PlayFX( TF1_SWAMP_BIRDS, player.EyePosition(), player.GetAngles() )
	EmitSoundOnEntityOnlyToPlayer( player, player, "AMB_Swampland_Emitter_Birdflock" )
	printt( "TF1_SWAMP_BIRD_BURST", player.EyePosition() )
}

void function TF1SwampScenes_AttackSchedule()
{
	while ( true )
	{
		wait 30.0
		if ( RandomInt(100) > 33 )
			continue
		file.attackCount = RandomIntRange( 2, 4 )
	}
}

string function TF1SwampScenes_AttackDropship( entity ref, string animation )
{
	if ( file.attackCount == 0 || (animation != DROPSHIP_STRAFE && animation != DROPSHIP_VERTICAL) )
		return animation
	bool vertical = animation == DROPSHIP_VERTICAL
	int count = file.attackCount
	file.attackCount = 0
	thread TF1SwampScenes_FlyerAttack( ref, count, vertical )
	return vertical ? DROPSHIP_FLYER_ATTACK_ANIM_VERTICAL : DROPSHIP_FLYER_ATTACK_ANIM
}

void function TF1SwampScenes_FlyerAttack( entity ref, int count, bool vertical )
{
	ref.EndSignal( "OnDestroy" )
	ref.WaitSignal( "WarpedIn" )
	WaitEndFrame()
	array<string> animations = vertical ?
		["flyer_dropshipattack_vertical_top", "flyer_dropshipattack_vertical_right", "flyer_dropshipattack_vertical_cockpit"] :
		["flyer_dropshipattack_top", "flyer_dropshipattack_right", "flyer_dropshipattack_cockpit"]
	if ( count < 3 && CoinFlip() )
		animations[1] = animations[2]
	array<entity> flyers
	OnThreadEnd(
		function() : ( flyers )
		{
			foreach ( flyer in flyers )
				if ( IsValid( flyer ) )
					flyer.Destroy()
		}
	)
	float duration = 0.0
	for ( int i = 0; i < count; i++ )
	{
		entity flyer = CreatePropDynamic( TF1_SWAMP_ATTACK_FLYER, ref.GetOrigin(), ref.GetAngles(), 0 )
		flyers.append( flyer )
		float length = flyer.GetSequenceDuration( animations[i] )
		if ( length <= 0.04 )
			throw "Swampland attack animation missing: " + animations[i]
		duration = max( duration, length )
		thread PlayAnimTeleport( flyer, animations[i], ref, 0.0 )
	}
	printt( "TF1_SWAMP_FLYER_ATTACK", count, vertical, duration )
	wait duration
}

void function TF1SwampScenes_Leviathan( int id, int start, bool fast, bool repeat, float delay )
{
	wait delay
	do
	{
		entity leviathan = CreatePropDynamic( TF1_SWAMP_LEVIATHAN, file.nodes[start].origin, file.nodes[start].angles, 0 )
		leviathan.SetOrigin( file.nodes[start].origin )
		leviathan.kv.fadedist = -1
		leviathan.Hide()
		SwampLeviathanState state = file.leviathans[id]
		state.prop = leviathan
		state.generation++
		state.animation = -1
		waitthread TF1SwampScenes_LeviathanPath( id, leviathan, start, fast )
		if ( !repeat )
			return
		WaitEndFrame()
	} while ( true )
}

void function TF1SwampScenes_LeviathanPath( int id, entity leviathan, int index, bool fast )
{
	leviathan.EndSignal( "OnDestroy" )
	OnThreadEnd(
		function() : ( id, leviathan )
		{
			SwampLeviathanState state = file.leviathans[id]
			foreach ( player in GetPlayerArray() )
				Remote_CallFunction_NonReplay( player, "ServerCallback_TF1SwampLeviathanRemove", id, state.generation )
			state.prop = null
			if ( IsValid( leviathan ) )
				leviathan.Destroy()
		}
	)
	bool walking = true
	printt( "TF1_SWAMP_LEVIATHAN_SPAWN", file.nodes[index].name, fast, leviathan.GetOrigin() )
	while ( file.nodes[index].children.len() > 0 )
	{
		array<int> children = file.nodes[index].children
		index = children[RandomInt(children.len())]
		SwampSceneNode node = file.nodes[index]
		if ( !walking )
			waitthread TF1SwampScenes_PlayLeviathan( id, leviathan, fast ? "leviathan_trans_2_walk_fast" : "lev_trans_2_walk_slow" )
		waitthread TF1SwampScenes_Walk( id, leviathan, node.origin, fast )
		walking = true
		printt( "TF1_SWAMP_LEVIATHAN_NODE", node.name, leviathan.GetOrigin() )
		if ( node.roar )
		{
			waitthread TF1SwampScenes_PlayLeviathan( id, leviathan, fast ? "leviathan_trans_2_idle_fast" : "lev_trans_2_idle" )
			waitthread TF1SwampScenes_PlayLeviathan( id, leviathan, CoinFlip() ? "lev_idle_lookup_noloop" : "leviathan_reaction_howl" )
			walking = false
		}
	}
}

void function TF1SwampScenes_Walk( int id, entity leviathan, vector destination, bool fast )
{
	array<float> thresholds = [0.94, 0.819, 0.342, -0.939, -1.0]
	array<array<string> > slow = [
		["lev_walk_slow"], ["lev_walk_slow_left", "lev_walk_slow_right"],
		["lev_walk_slow_left", "lev_walk_slow_right"],
		["lev_walk_slow_left", "lev_walk_slow_right"],
		["lev_walk_slow_left", "lev_walk_slow_right"]
	]
	array<array<string> > quick = [
		["leviathan_walk_fast"], ["leviathan_walk_fast_left", "leviathan_walk_fast_right"],
		["leviathan_walk_fast_left_sharp", "leviathan_walk_fast_right_sharp"],
		["leviathan_walk_90turn_left", "leviathan_walk_90turn_right"],
		["leviathan_walk_180turn_left", "leviathan_walk_180turn_right"]
	]
	vector start = leviathan.GetOrigin()
	float deadline = Time() + 300.0
	while ( true )
	{
		vector origin = leviathan.GetOrigin()
		vector direction = destination - origin
		direction.z = 0
		float distance = Length( direction )
		if ( distance < 0.1 )
			return
		direction = Normalize( direction )
		float forward = DotProduct( leviathan.GetForwardVector(), direction )
		float right = DotProduct( leviathan.GetRightVector(), direction )
		array<array<string> > sets = fast ? quick : slow
		string animation = sets[4][right < 0 ? 0 : 1]
		for ( int i = 0; i < thresholds.len(); i++ )
		{
			if ( forward >= thresholds[i] )
			{
				animation = sets[i][sets[i].len() == 1 || right < 0 ? 0 : 1]
				break
			}
		}
		vector end = leviathan.GetAnimEndPos( leviathan.LookupSequence( animation ), 0, 1 )
		float cycle = Distance2D( origin, end )
		float remaining = Distance2D( destination, end )
		if ( Distance2D(start, origin) > distance && (remaining < cycle || remaining > distance) )
			return
		if ( Time() > deadline )
			throw "Swampland Leviathan cannot reach source route node"
		waitthread TF1SwampScenes_PlayLeviathan( id, leviathan, animation )
	}
}

void function TF1SwampScenes_PlayLeviathan( int id, entity leviathan, string animation )
{
	SwampLeviathanState state = file.leviathans[id]
	state.animation = TF1SwampScenes_LeviathanAnimations().find( animation )
	if ( state.animation < 0 )
		throw "Unregistered Swampland Leviathan animation: " + animation
	state.origin = leviathan.GetOrigin()
	state.angles = leviathan.GetAngles()
	state.started = Time()
	foreach ( player in GetPlayerArray() )
		TF1SwampScenes_SendLeviathan( player, id )
	waitthread PlayAnim( leviathan, animation )
}

void function TF1SwampScenes_SendLeviathan( entity player, int id )
{
	SwampLeviathanState state = file.leviathans[id]
	if ( !IsValid( state.prop ) || state.animation < 0 )
		return
	vector origin = state.origin
	vector angles = state.angles
	Remote_CallFunction_NonReplay( player, "ServerCallback_TF1SwampLeviathan", id, state.generation,
		state.animation, origin.x, origin.y, origin.z, angles.x, angles.y, angles.z, Time() - state.started )
}

void function TF1SwampScenes_SyncPlayer( entity player )
{
	for ( int id = 0; id < file.leviathans.len(); id++ )
		TF1SwampScenes_SendLeviathan( player, id )
}
