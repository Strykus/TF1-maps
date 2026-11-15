untyped
global function TF1Outpost_FastballInit

void function TF1Outpost_FastballInit()
{
 if ( GetMapName() != "mp_tf1_outpost_207" || GameRules_GetGameMode() != "fastball" ) return
 SetSpawnpointGamemodeOverride( TEAM_DEATHMATCH )
 ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP( true )
 FastballAddPanelSpawnsForLevel( "mp_tf1_outpost_207", [
  < -584.2122192, 40.91995621, -63.96875 >, < 0, -147.3554535, 0 >,
  < 1415.407715, 2198.66748, -191.96875 >, < 0, 91.34368896, 0 >,
  < 3316.037598, 1645.34436, -159.96875 >, < 0, 118.6074829, 0 >
 ] )
 AddCallback_EntitiesDidLoad( TF1Outpost_FastballEntitiesLoaded )
}

void function TF1Outpost_FastballEntitiesLoaded()
{
 thread TF1Outpost_FastballCheckPanels()
}

void function TF1Outpost_FastballCheckPanels()
{
 WaitFrame()
 int count = 0
 foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
 {
  if ( !( "scriptedPanel" in panel.s ) || !( "panelId" in panel.s ) ) continue
  count++
  vector origin = panel.GetOrigin()
  TraceResults floor = TraceLine( origin + < 0, 0, 96 >, origin - < 0, 0, 160 >, panel, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
  if ( !floor.startSolid && floor.fraction < 1.0 ) panel.SetOrigin( floor.endPos )
  printt( "TF1_OUTPOST_FASTBALL_PANEL", panel.s.panelId, panel.GetOrigin(), panel.GetAngles().y )
 }
 Assert( count == 3, "Outpost Fastball requires exactly three game panels" )
 printt( "TF1_OUTPOST_FASTBALL_PANELS_READY", count )
}
