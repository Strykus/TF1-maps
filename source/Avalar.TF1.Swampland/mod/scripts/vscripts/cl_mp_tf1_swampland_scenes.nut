global function TF1SwampScenes_ClientPrecache
global function TF1SwampScenes_ClientInit
global function TF1SwampScenes_ClientShutdown
global function ServerCallback_TF1SwampLeviathan
global function ServerCallback_TF1SwampLeviathanRemove
global function ServerCallback_TF1SwampPulse

const asset TF1_SWAMP_LEVIATHAN_VISUAL = $"models/creatures/leviathan/leviathan_swampland_small.mdl"
const vector TF1_SWAMP_SKY_ORIGIN = < -8192, 9216, -8960 >

struct SwampLeviathanVisual
{
	entity prop
	int generation = -1
}

struct
{
	bool active = false
	array<SwampLeviathanVisual> visuals
	entity tower
} file

void function TF1SwampScenes_ClientPrecache()
{
	if ( GetMapName() == "mp_tf1_swampland" )
		PrecacheModel( TF1_SWAMP_LEVIATHAN_VISUAL )
}

void function TF1SwampScenes_ClientInit()
{
	if ( GetMapName() != "mp_tf1_swampland" )
		return
	file.active = true
	for ( int i = 0; i < 3; i++ )
	{
		SwampLeviathanVisual visual
		file.visuals.append( visual )
	}
	AddCreateCallback( "prop_dynamic", TF1SwampScenes_TowerCreated )
}

void function TF1SwampScenes_ClientShutdown()
{
	file.active = false
	foreach ( visual in file.visuals )
		if ( IsValid( visual.prop ) )
			visual.prop.Destroy()
	file.visuals.clear()
	if ( IsValid( file.tower ) )
		StopSoundOnEntity( file.tower, "airbase_scr_dogwhistle_idle" )
	file.tower = null
}

void function TF1SwampScenes_TowerCreated( entity tower )
{
	string name = tower.GetTargetName()
	if ( name != "prop_airbase_tower_main" && name != "prop_airbase_tower" )
		return
	if ( file.tower == tower )
		return
	file.tower = tower
	EmitSoundOnEntity( tower, "airbase_scr_dogwhistle_idle" )
	printt( "TF1_SWAMP_TOWER_AUDIO_READY" )
}

void function ServerCallback_TF1SwampPulse()
{
	if ( !file.active )
		return
	EmitSoundAtPosition( TEAM_UNASSIGNED, <438, -6354, 4604>, "airbase_scr_dogwhistle_pulse" )
	printt( "TF1_SWAMP_PULSE_AUDIO", Time() )
}

void function ServerCallback_TF1SwampLeviathan( int id, int generation, int animation,
	float x, float y, float z, float pitch, float yaw, float roll, float elapsed )
{
	if ( !file.active )
		return
	if ( id < 0 || id >= file.visuals.len() )
		throw "Invalid Swampland Leviathan visual id"
	array<string> animations = TF1SwampScenes_LeviathanAnimations()
	if ( animation < 0 || animation >= animations.len() )
		throw "Invalid Swampland Leviathan visual animation"
	SwampLeviathanVisual visual = file.visuals[id]
	if ( generation < visual.generation )
		return
	vector origin = <x, y, z>
	vector angles = <pitch, yaw, roll>
	if ( generation != visual.generation || !IsValid( visual.prop ) )
	{
		if ( IsValid( visual.prop ) )
			visual.prop.Destroy()
		visual.generation = generation
		visual.prop = CreatePropDynamic( TF1_SWAMP_LEVIATHAN_VISUAL, origin, angles )
		visual.prop.SetFadeDistance( 36000 )
		visual.prop.EnableRenderAlways()
		AddAnimEvent( visual.prop, "LeviathanFootstep", TF1SwampScenes_Footstep )
		AddAnimEvent( visual.prop, "LeviathanReactionSmall", TF1SwampScenes_ReactionSmall )
		AddAnimEvent( visual.prop, "LeviathanReactionBig", TF1SwampScenes_ReactionBig )
		AddAnimEvent( visual.prop, "LeviathanDeathVocal", TF1SwampScenes_DeathVocal )
		AddAnimEvent( visual.prop, "LeviathanBodyfall", TF1SwampScenes_DeathVocal )
		printt( "TF1_SWAMP_LEVIATHAN_VISUAL", id, generation, origin )
	}
	entity prop = visual.prop
	prop.SetOrigin( origin )
	prop.SetAngles( angles )
	prop.Anim_PlayWithRefPoint( animations[animation], origin, angles, DEFAULT_SCRIPTED_ANIMATION_BLEND_TIME )
	if ( elapsed > 0.0 )
		prop.Anim_SetInitialTime( min( elapsed, max( 0.0, prop.GetSequenceDuration( animations[animation] ) - 0.01 ) ) )
}

void function ServerCallback_TF1SwampLeviathanRemove( int id, int generation )
{
	if ( !file.active )
		return
	if ( id < 0 || id >= file.visuals.len() )
		throw "Invalid Swampland Leviathan removal id"
	SwampLeviathanVisual visual = file.visuals[id]
	if ( visual.generation != generation )
		return
	if ( IsValid( visual.prop ) )
		visual.prop.Destroy()
	visual.prop = null
}

void function TF1SwampScenes_CreatureSound( entity leviathan, string event )
{
	// Skybox coordinates must be expanded before positional audio attenuation.
	vector position = ( leviathan.GetOrigin() - TF1_SWAMP_SKY_ORIGIN ) * 1000.0
	EmitSoundAtPosition( TEAM_UNASSIGNED, position, event )
	printt( "TF1_SWAMP_LEVIATHAN_AUDIO", event, position )
}

void function TF1SwampScenes_Footstep( entity leviathan )
{
	TF1SwampScenes_CreatureSound( leviathan, "Leviathan_Footstep" )
}

void function TF1SwampScenes_ReactionSmall( entity leviathan )
{
	TF1SwampScenes_CreatureSound( leviathan, "Leviathan_Reaction_Small" )
}

void function TF1SwampScenes_ReactionBig( entity leviathan )
{
	TF1SwampScenes_CreatureSound( leviathan, "Leviathan_Reaction_Big" )
}

void function TF1SwampScenes_DeathVocal( entity leviathan )
{
	TF1SwampScenes_CreatureSound( leviathan, "Leviathan_DeathVocal" )
}
