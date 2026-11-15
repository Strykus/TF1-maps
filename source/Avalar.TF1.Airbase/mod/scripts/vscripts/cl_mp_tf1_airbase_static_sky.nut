global function TF1AirbaseStaticSky_Precache
global function TF1AirbaseStaticSky_Init
global function TF1AirbaseStaticSky_Shutdown

const asset TF1_AIRBASE_STATIC_CARRIER = $"models/tf1_airbase/sky_carrier.mdl"
const asset TF1_AIRBASE_SKY_RADAR_ANCHOR = $"models/imc_base/worker_base_whistle_tower_skybox.mdl"
const asset TF1_AIRBASE_SKY_TOWER_LIGHT = $"tf1_airbase_distant_tower_light_red"

struct
{
	entity carrier
	array<entity> towers
	array<entity> dishes
	array<int> lights
	array<asset> radarModels = [
		$"models/imc_base/radar_a_skybox.mdl", $"models/imc_base/radar_b_skybox.mdl", $"models/imc_base/radar_c_skybox.mdl",
		$"models/imc_base/radar_d_skybox.mdl", $"models/imc_base/radar_e_skybox.mdl", $"models/imc_base/radar_f_skybox.mdl",
		$"models/imc_base/radar_g_skybox.mdl", $"models/imc_base/radar_h_skybox.mdl", $"models/imc_base/radar_i_skybox.mdl"
	]
	array<string> attachments = [
		"def_radar_a", "def_radar_b", "def_radar_c", "def_radar_d", "def_radar_e",
		"def_radar_f", "def_radar_g", "def_radar_h", "def_radar_i"
	]
	array<float> yawOffsets = [ -90.0, 90.0, -90.0, 90.0, 90.0, -90.0, 90.0, -90.0, 90.0 ]
} file

void function TF1AirbaseStaticSky_Precache()
{
	if ( GetMapName() != "mp_tf1_airbase" )
		return
	PrecacheModel( TF1_AIRBASE_STATIC_CARRIER )
	PrecacheModel( TF1_AIRBASE_SKY_RADAR_ANCHOR )
	foreach ( model in file.radarModels )
		PrecacheModel( model )
	PrecacheParticleSystem( TF1_AIRBASE_SKY_TOWER_LIGHT )
}

void function TF1AirbaseStaticSky_Init()
{
	if ( GetMapName() != "mp_tf1_airbase" || IsValid( file.carrier ) )
		return

	try
	{
		file.carrier = CreateClientsideScriptMover( TF1_AIRBASE_STATIC_CARRIER, < -10788, 7644, -6400 >, < 0, 180, 0 > )
		file.carrier.EnableRenderAlways()
		printt( "TF1_AIRBASE_STATIC_CARRIER_READY" )
		TF1AirbaseStaticSky_AddDishes( < -10717.0, 7587.2, -6400.0 >, < 0, 45, 0 > )
		TF1AirbaseStaticSky_AddDishes( < -10691.4, 7614.6, -6400.0 >, < 0, 290, 0 > )
		printt( "TF1_AIRBASE_STATIC_DISHES_READY", file.dishes.len() )
		printt( "TF1_AIRBASE_STATIC_TOWER_LIGHTS_READY", file.lights.len() )
	}
	catch ( error )
	{
		printt( "TF1_AIRBASE_STATIC_SKY_FAILED", error )
	}
}

void function TF1AirbaseStaticSky_AddDishes( vector origin, vector angles )
{
	entity anchor = CreateClientsideScriptMover( TF1_AIRBASE_SKY_RADAR_ANCHOR, origin, angles )
	anchor.EnableRenderAlways()
	file.towers.append( anchor )
	for ( int i = 0; i < file.radarModels.len(); i++ )
	{
		int attachment = anchor.LookupAttachment( file.attachments[i] )
		if ( attachment <= 0 )
			continue
		vector dishAngles = anchor.GetAttachmentAngles( attachment )
		dishAngles.y += file.yawOffsets[i]
		vector dishOrigin = anchor.GetAttachmentOrigin( attachment )
		entity dish = CreateClientsideScriptMover( file.radarModels[i], dishOrigin, dishAngles )
		dish.EnableRenderAlways()
		file.dishes.append( dish )
		int lightIndex = GetParticleSystemIndex( TF1_AIRBASE_SKY_TOWER_LIGHT )
		if ( lightIndex > 0 )
			file.lights.append( StartParticleEffectInWorldWithHandle( lightIndex, dishOrigin, angles ) )
	}
}

void function TF1AirbaseStaticSky_Shutdown()
{
	if ( IsValid( file.carrier ) )
		file.carrier.Destroy()
	file.carrier = null
	foreach ( dish in file.dishes )
		if ( IsValid( dish ) )
			dish.Destroy()
	file.dishes.clear()
	foreach ( light in file.lights )
		if ( EffectDoesExist( light ) )
			EffectStop( light, true, false )
	file.lights.clear()
	foreach ( tower in file.towers )
		if ( IsValid( tower ) )
			tower.Destroy()
	file.towers.clear()
}
