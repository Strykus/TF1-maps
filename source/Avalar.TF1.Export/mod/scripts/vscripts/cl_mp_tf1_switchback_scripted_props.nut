global function TF1Port_mp_tf1_switchback_ScriptedProps_Precache
global function TF1Port_mp_tf1_switchback_ScriptedProps_Init
global function TF1Port_mp_tf1_switchback_ScriptedProps_Shutdown

// TF1 spawned these animated props from its client level script. They are not
// part of the BSP, so the porter recreates them here with the original models,
// positions and animation names.
const asset LIFT_MODEL = $"models/props/lift/lift.mdl"
const asset LIFT_SHIP_MODEL = $"models/props/supply_barge/lift_ship.mdl"
const asset GREENHOUSE_FAN_BLADE_MODEL = $"models/props/greenhouse_fan_blade/greenhouse_fan_blade_animated.mdl"

struct LiftShip
{
	entity model
	int attachNum = 0
	bool moving = false
}

struct
{
	bool active = false
	entity lift
	array<LiftShip> ships
	array<entity> props
} file

// Runs in the Before phase, while model precaching is still allowed.
void function TF1Port_mp_tf1_switchback_ScriptedProps_Precache()
{
	if ( GetMapName() != "mp_tf1_switchback" )
		return

	PrecacheModel( LIFT_MODEL )
	PrecacheModel( LIFT_SHIP_MODEL )
	PrecacheModel( GREENHOUSE_FAN_BLADE_MODEL )
}

void function TF1Port_mp_tf1_switchback_ScriptedProps_Init()
{
	if ( GetMapName() != "mp_tf1_switchback" )
		return

	file.active = true
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_switchback_ScriptedProps_Spawn )
}

void function TF1Port_mp_tf1_switchback_ScriptedProps_Shutdown()
{
	if ( !file.active )
		return

	file.active = false
	foreach ( ent in file.props )
	{
		if ( IsValid( ent ) )
			ent.Destroy()
	}
	foreach ( ship in file.ships )
	{
		if ( IsValid( ship.model ) )
			ship.model.Destroy()
	}
	file.props.clear()
	file.ships.clear()
}

void function TF1Port_mp_tf1_switchback_ScriptedProps_Spawn()
{
	if ( !file.active )
		return

	thread TF1Port_mp_tf1_switchback_LiftAnimate()
	TF1Port_mp_tf1_switchback_GreenhouseFans()
}

void function TF1Port_mp_tf1_switchback_GreenhouseFans()
{
	entity blade1 = CreateClientSidePropDynamic( Vector( 1400.0, 1792.0, 1110.0 ), Vector( 0.0, 0.0, 0.0 ), GREENHOUSE_FAN_BLADE_MODEL )
	blade1.Anim_Play( "fan_cycle_slow" )
	file.props.append( blade1 )

	entity blade2 = CreateClientSidePropDynamic( Vector( 1400.0, 1792.0, 1058.0 ), Vector( 0.0, 0.0, 0.0 ), GREENHOUSE_FAN_BLADE_MODEL )
	blade2.Anim_Play( "fan_cycle_slow" )
	blade2.Anim_SetInitialTime( blade2.GetSequenceDuration( "fan_cycle_slow" ) * 0.125 )
	file.props.append( blade2 )
}

void function TF1Port_mp_tf1_switchback_LiftAnimate()
{
	for ( int i = 0; i < 5; i++ )
	{
		LiftShip ship
		ship.model = CreateClientsideScriptMover( LIFT_SHIP_MODEL, Vector( 0.0, 0.0, -1000.0 ), Vector( 0.0, 0.0, 0.0 ) )
		ship.model.DisableDraw()
		file.ships.append( ship )
	}

	entity lift = CreateClientSidePropDynamic( Vector( -53.906242, -3933.999512, 818.499878 ), Vector( 0.0, 90.0, 0.0 ), LIFT_MODEL )
	file.lift = lift
	file.props.append( lift )
	lift.EndSignal( "OnDestroy" )

	AddAnimEvent( lift, "LiftAttachShip1", TF1Port_mp_tf1_switchback_LiftAttachShip1 )
	AddAnimEvent( lift, "LiftDetachShip1", TF1Port_mp_tf1_switchback_LiftDetachShip1 )
	AddAnimEvent( lift, "LiftAttachShip2", TF1Port_mp_tf1_switchback_LiftAttachShip2 )
	AddAnimEvent( lift, "LiftDetachShip2", TF1Port_mp_tf1_switchback_LiftDetachShip2 )
	AddAnimEvent( lift, "LiftAttachShip3", TF1Port_mp_tf1_switchback_LiftAttachShip3 )
	AddAnimEvent( lift, "LiftDetachShip3", TF1Port_mp_tf1_switchback_LiftDetachShip3 )

	lift.Anim_Play( "lift_cycle" )
	lift.Anim_SetInitialTime( Time() )
	while ( true )
	{
		WaittillAnimDone( lift )
		lift.Anim_Play( "lift_cycle" )
	}
}

void function TF1Port_mp_tf1_switchback_LiftAttachShip1( entity lift ) { TF1Port_mp_tf1_switchback_LiftAttachShip( "SHIP_1", 1 ) }
void function TF1Port_mp_tf1_switchback_LiftDetachShip1( entity lift ) { TF1Port_mp_tf1_switchback_LiftDetachShip( 1 ) }
void function TF1Port_mp_tf1_switchback_LiftAttachShip2( entity lift ) { TF1Port_mp_tf1_switchback_LiftAttachShip( "SHIP_2", 2 ) }
void function TF1Port_mp_tf1_switchback_LiftDetachShip2( entity lift ) { TF1Port_mp_tf1_switchback_LiftDetachShip( 2 ) }
void function TF1Port_mp_tf1_switchback_LiftAttachShip3( entity lift ) { TF1Port_mp_tf1_switchback_LiftAttachShip( "SHIP_3", 3 ) }
void function TF1Port_mp_tf1_switchback_LiftDetachShip3( entity lift ) { TF1Port_mp_tf1_switchback_LiftDetachShip( 3 ) }

void function TF1Port_mp_tf1_switchback_LiftAttachShip( string attachment, int attachNum )
{
	if ( !IsValid( file.lift ) )
		return

	int pick = -1
	for ( int i = 0; i < file.ships.len(); i++ )
	{
		LiftShip ship = file.ships[i]
		if ( ship.attachNum == attachNum )
			return
		if ( pick < 0 && ship.attachNum == 0 && !ship.moving )
			pick = i
	}
	if ( pick < 0 )
		return

	LiftShip ship = file.ships[pick]
	int attachmentID = file.lift.LookupAttachment( attachment )
	if ( attachmentID <= 0 )
		return

	vector origin = file.lift.GetAttachmentOrigin( attachmentID )
	vector angles = file.lift.GetAttachmentAngles( attachmentID )
	// Skip frames where the animated skeleton has not been evaluated yet.
	if ( origin.x != origin.x || origin.y != origin.y || origin.z != origin.z || fabs( origin.x ) > 30000 || fabs( origin.y ) > 30000 || fabs( origin.z ) > 30000 )
		return

	ship.attachNum = attachNum
	ship.model.SetOrigin( origin )
	ship.model.SetAngles( angles )
	ship.model.SetParent( file.lift, attachment, false, 0.0 )
	ship.model.EnableDraw()
}

void function TF1Port_mp_tf1_switchback_LiftDetachShip( int attachNum )
{
	foreach ( ship in file.ships )
	{
		if ( ship.attachNum != attachNum )
			continue

		ship.attachNum = 0
		ship.model.ClearParent()
		thread TF1Port_mp_tf1_switchback_LiftMoveShip( ship )
		return
	}
}

void function TF1Port_mp_tf1_switchback_LiftMoveShip( LiftShip ship )
{
	entity model = ship.model
	model.EndSignal( "OnDestroy" )
	ship.moving = true

	OnThreadEnd(
		function() : ( ship )
		{
			ship.moving = false
		}
	)

	model.NonPhysicsMoveTo( Vector( -53.0, -2419.0, 2580.0 ), 5.0, 2.0, 3.0 )
	model.NonPhysicsRotateTo( Vector( 0.0, -90.0, 0.0 ), 5.0, 2.0, 3.0 )
	wait 5.0
	model.NonPhysicsMoveTo( Vector( -53.0, 5581.0, 2580.0 ), 24.0, 3.0, 0.0 )
	wait 24.0
	model.DisableDraw()
}
