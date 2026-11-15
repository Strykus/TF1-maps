global function TF1AirbaseTower_ClientPrecache
global function TF1AirbaseTower_ClientInit
global function TF1AirbaseTower_ClientShutdown

struct
{
	bool active = false
	entity tower
	array<asset> models = [
		$"models/tf1_airbase/radar_a.mdl", $"models/tf1_airbase/radar_b.mdl",
		$"models/tf1_airbase/radar_c.mdl", $"models/tf1_airbase/radar_d.mdl",
		$"models/tf1_airbase/radar_e.mdl", $"models/tf1_airbase/radar_f.mdl",
		$"models/tf1_airbase/radar_g.mdl", $"models/tf1_airbase/radar_h.mdl",
		$"models/tf1_airbase/radar_i.mdl"
	]
	array<string> attachments = [
		"def_radar_a", "def_radar_b", "def_radar_c", "def_radar_d",
		"def_radar_e", "def_radar_f", "def_radar_g", "def_radar_h", "def_radar_i"
	]
	array<float> periods = [40.0, 25.0, 30.0, 70.0, 35.0, 60.0, 50.0, 90.0, 45.0]
	array<float> offsets = [-90.0, 90.0, -90.0, 90.0, 90.0, -90.0, 90.0, -90.0, 90.0]
	array<float> directions = [1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, -1.0, 1.0]
	array<entity> radars
} file

void function TF1AirbaseTower_ClientPrecache()
{
	if ( GetMapName() != "mp_tf1_airbase" )
		return
	foreach ( model in file.models )
		PrecacheModel( model )
}

void function TF1AirbaseTower_ClientInit()
{
	if ( GetMapName() != "mp_tf1_airbase" )
		return
	file.active = true
	AddCreateCallback( "prop_dynamic", TF1AirbaseTower_Created )
}

void function TF1AirbaseTower_ClientShutdown()
{
	file.active = false
	foreach ( radar in file.radars )
	{
		if ( IsValid( radar ) )
			radar.Destroy()
	}
	file.radars.clear()
	file.tower = null
}

void function TF1AirbaseTower_Created( entity tower )
{
	if ( !file.active || file.tower == tower || tower.GetTargetName() != "prop_airbase_tower" )
		return
	file.tower = tower
	thread TF1AirbaseTower_Radars( tower )
}

void function TF1AirbaseTower_Radars( entity tower )
{
	tower.EndSignal( "OnDestroy" )
	array<entity> radars
	OnThreadEnd(
		function() : ( radars )
		{
			foreach ( radar in radars )
			{
				if ( IsValid( radar ) )
					radar.Destroy()
			}
		}
	)
	WaitEndFrame()
	if ( !file.active )
		return
	for ( int i = 0; i < file.models.len(); i++ )
	{
		int attachment = tower.LookupAttachment( file.attachments[i] )
		if ( attachment <= 0 )
			throw "Airbase tower missing radar attachment: " + file.attachments[i]
		entity radar = CreateClientsideScriptMover( file.models[i], tower.GetAttachmentOrigin( attachment ), <0, 0, 0> )
		radars.append( radar )
		file.radars.append( radar )
		radar.NonPhysicsSetRotateModeLocal( true )
		radar.SetParent( tower, file.attachments[i], true, 0.0 )
		radar.MarkAsNonMovingAttachment()
		radar.NonPhysicsRotateTo( <0, file.offsets[i], 0>, 0.016, 0.0, 0.0 )
	}
	printt( "TF1_AIRBASE_RADARS_READY", radars.len() )
	WaitEndFrame()
	array<float> angles = clone file.offsets
	float nextReport = Time() + 5.0
	bool reported = false
	while ( file.active )
	{
		for ( int i = 0; i < radars.len(); i++ )
		{
			angles[i] = AngleNormalize( angles[i] + file.directions[i] * 360.0 / file.periods[i] )
			radars[i].NonPhysicsRotateTo( <0, angles[i], 0>, 1.0, 0.0, 0.0 )
		}
		wait 1.0
		if ( !reported && file.active && Time() >= nextReport )
		{
			printt( "TF1_AIRBASE_RADARS_ROTATING", radars[0].GetLocalAngles() )
			reported = true
		}
	}
}
