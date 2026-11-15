global function TF1AirbaseTower_ServerPrecache
global function TF1AirbaseTower_ServerInit

void function TF1AirbaseTower_ServerPrecache()
{
	if ( GetMapName() != "mp_tf1_airbase" )
		return
	foreach ( model in [
		$"models/tf1_airbase/radar_a.mdl", $"models/tf1_airbase/radar_b.mdl",
		$"models/tf1_airbase/radar_c.mdl", $"models/tf1_airbase/radar_d.mdl",
		$"models/tf1_airbase/radar_e.mdl", $"models/tf1_airbase/radar_f.mdl",
		$"models/tf1_airbase/radar_g.mdl", $"models/tf1_airbase/radar_h.mdl",
		$"models/tf1_airbase/radar_i.mdl"
	] )
		PrecacheModel( model )
}

void function TF1AirbaseTower_ServerInit()
{
	if ( GetMapName() != "mp_tf1_airbase" )
		return
	AddCallback_EntitiesDidLoad( TF1AirbaseTower_SetPose )
}

void function TF1AirbaseTower_SetPose()
{
	entity tower = GetEnt( "prop_airbase_tower" )
	if ( !IsValid( tower ) )
		throw "Airbase tower entity missing"
	float duration = tower.GetSequenceDuration( "worker_base_whistle_tower_idle_new" )
	if ( duration <= 0.0 )
		throw "Airbase tower idle sequence missing"
	tower.Anim_Play( "worker_base_whistle_tower_idle_new" )
	printt( "TF1_AIRBASE_TOWER_POSE", duration )
}
