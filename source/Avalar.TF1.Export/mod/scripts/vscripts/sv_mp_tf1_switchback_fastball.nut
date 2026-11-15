untyped
global function TF1Port_mp_tf1_switchback_Fastball_Init

// Fastball only ships panel points for stock maps, so Export needs its own: panel A (IMC
// side), B (middle) and C (Militia side). Each console stands where the author looked in
// the game: the view is stored as the eye position and view angles, and the console is put
// on the first surface the view ray hits, so it always rests on the real floor.
// BT intro spawns need no data: Fastball derives them from info_spawnpoint_titan_start.
void function TF1Port_mp_tf1_switchback_Fastball_Init()
{
	if ( GetMapName() != "mp_tf1_switchback" )
		return

	// placeholder points: the real heights are fixed after the panels exist
	FastballAddPanelSpawnsForLevel(
		"mp_tf1_switchback",
		[ < 858.2, 1760.9, 240.1 >, < 0, 1.6, 0 >, < 353.2, -653.0, 452.0 >, < 0, 178.2, 0 >, < -2581.3, 2218.5, 964.0 >, < 0, 177.0, 0 > ]
	)
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_switchback_Fastball_OnEntitiesLoaded )
}

// Fastball numbers every control panel of the map, and panels it did not create have no
// panel id, which makes the mode fail with: The index "panelId" does not exist.
void function TF1Port_mp_tf1_switchback_Fastball_OnEntitiesLoaded()
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
	printt( "TF1_EXPORT_FASTBALL map consoles removed", removed )

	thread TF1Port_mp_tf1_switchback_Fastball_PlacePanels()
}

void function TF1Port_mp_tf1_switchback_Fastball_PlacePanels()
{
	WaitFrame()

	// player origin + eye height (64), and view angles (pitch, yaw) from the author's screenshots
	array<vector> eyes = [ < 952.2, 1763.6, 304.1 >, < 251.3, -649.7, 516.0 >, < -2691.2, 2224.3, 1028.0 > ]
	array<vector> views = [ < 34.24, -178.36, 0 >, < 32.12, -1.85, 0 >, < 30.19, -3.03, 0 > ]
	// exact player coordinates given by the author where the view ray is not enough
	// (console A: the player origin standing next to it, on the real floor)
	array<vector> fixedPos = [ < 1106.15, 1758.84, 842.72 >, < 0, 0, 0 >, < 0, 0, 0 > ]

	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		if ( !( "scriptedPanel" in panel.s ) )
			continue

		int id = expect int( panel.s.panelId )
		if ( id >= eyes.len() )
			continue

		vector origin = panel.GetOrigin()
		if ( fixedPos[ id ] != < 0, 0, 0 > )
		{
			// the author's coordinates can be taken in the air (jump, wall run), so the console
			// is dropped from that point onto the first floor below it
			vector start = fixedPos[ id ] + < 0, 0, 8 >
			TraceResults down = TraceLine( start, start - < 0, 0, 700 >, panel, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
			vector landed = fixedPos[ id ]
			if ( !down.startSolid && down.fraction < 1.0 )
				landed = down.endPos

			printt( "TF1_EXPORT_FASTBALL panel", id, origin, "-> fixed", fixedPos[ id ], "dropped to", landed, "fell", fixedPos[ id ].z - landed.z )
			panel.SetOrigin( landed )
			continue
		}

		vector forward = AnglesToForward( views[ id ] )
		TraceResults hit = TraceLine( eyes[ id ], eyes[ id ] + forward * 4096, panel, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
		if ( hit.fraction >= 1.0 )
		{
			printt( "TF1_EXPORT_FASTBALL panel", id, "view ray hit nothing, kept", origin )
			continue
		}

		printt( "TF1_EXPORT_FASTBALL panel", id, origin, "->", hit.endPos )
		panel.SetOrigin( hit.endPos )
	}
}
