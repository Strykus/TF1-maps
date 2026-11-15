global function TF1Port_mp_tf1_nexus_Fastball_Init

// Fastball only ships panel points for stock maps, so Nexus needs its own: the first
// point is panel A (IMC side), the second B (middle), the third C (Militia side).
// Every point is an info_spawnpoint_human of the map, so it stands on open floor.
// BT intro spawns need no data: Fastball derives them from info_spawnpoint_titan_start.
void function TF1Port_mp_tf1_nexus_Fastball_Init()
{
	if ( GetMapName() != "mp_tf1_nexus" )
		return

	FastballAddPanelSpawnsForLevel(
		"mp_tf1_nexus",
		[ < -3884, 660, 200 >, < 0, -90, 0 >, < -1348, -884, 8 >, < 0, -90, 0 >, < 2360, 1508, 280 >, < 0, 90, 0 > ]
	)
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_nexus_Fastball_OnEntitiesLoaded )
}

// Fastball numbers every control panel of the map, and the two TF1 turret consoles
// have no panel id, which made the mode fail with: The index "panelId" does not exist.
void function TF1Port_mp_tf1_nexus_Fastball_OnEntitiesLoaded()
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
	printt( "TF1_NEXUS_FASTBALL turret consoles removed", removed )

	thread TF1Port_mp_tf1_nexus_Fastball_SnapPanelsToFloor()
}

// The panel points come from spawn points, whose height is not exactly the floor, so
// the consoles are dropped onto the real floor once Fastball has created them.
void function TF1Port_mp_tf1_nexus_Fastball_SnapPanelsToFloor()
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
			printt( "TF1_NEXUS_FASTBALL panel kept", origin )
			continue
		}

		printt( "TF1_NEXUS_FASTBALL panel floor", origin.z, "->", floor.endPos.z )
		panel.SetOrigin( floor.endPos )
	}
}
