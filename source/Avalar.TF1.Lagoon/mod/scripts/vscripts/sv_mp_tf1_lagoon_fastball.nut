global function TF1Port_mp_tf1_lagoon_Fastball_Init

// Control panel points chosen in game with TF1.PlacementTool:
// A, B and C in the order Fastball numbers them.
void function TF1Port_mp_tf1_lagoon_Fastball_Init()
{
	if ( GetMapName() != "mp_tf1_lagoon" )
		return

	FastballAddPanelSpawnsForLevel(
		"mp_tf1_lagoon",
		[ < -2221.613, 1175.118, 119.531 >, < 0, -90, 0 >, < 4531.624, 312.208, 752.031 >, < 0, 168, 0 >, < -974.039, 4769.093, 189.531 >, < 0, -88, 0 > ]
	)
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_lagoon_Fastball_OnEntitiesLoaded )
}

// Native TF1 consoles without a Fastball panel id would break the mode.
void function TF1Port_mp_tf1_lagoon_Fastball_OnEntitiesLoaded()
{
	if ( GameRules_GetGameMode() != "fastball" )
		return

	int removed = 0
	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		if ( "scriptedPanel" in panel.s )
			continue
		panel.Destroy()
		removed++
	}
	printt( "TF1_LAGOON_FASTBALL foreign consoles removed", removed )

	thread TF1Port_mp_tf1_lagoon_Fastball_SnapPanelsToFloor()
}

void function TF1Port_mp_tf1_lagoon_Fastball_SnapPanelsToFloor()
{
	WaitFrame()

	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		if ( !( "scriptedPanel" in panel.s ) )
			continue

		vector origin = panel.GetOrigin()
		TraceResults floor = TraceLine( origin + < 0, 0, 96 >, origin - < 0, 0, 160 >, panel, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( floor.startSolid || floor.fraction >= 1.0 )
		{
			printt( "TF1_LAGOON_FASTBALL panel kept", origin )
			continue
		}

		printt( "TF1_LAGOON_FASTBALL panel floor", origin.z, "->", floor.endPos.z )
		panel.SetOrigin( floor.endPos )
	}
}