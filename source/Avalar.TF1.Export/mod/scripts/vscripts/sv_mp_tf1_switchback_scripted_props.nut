global function TF1Port_mp_tf1_switchback_ScriptedProps_ServerInit
void function TF1Port_mp_tf1_switchback_ScriptedProps_ServerInit()
{
	if ( GetMapName() != "mp_tf1_switchback" )
		return

	PrecacheModel( $"models/props/lift/lift.mdl" )
	PrecacheModel( $"models/props/supply_barge/lift_ship.mdl" )
	PrecacheModel( $"models/props/greenhouse_fan_blade/greenhouse_fan_blade_animated.mdl" )
}
