untyped
global function TF1SwampFastball_Init

void function TF1SwampFastball_Init()
{
 if ( GetMapName() != "mp_tf1_swampland" || GameRules_GetGameMode() != "fastball" )
  return
 ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP( true )
 FastballAddPanelSpawnsForLevel( "mp_tf1_swampland", [ < -1713.4951171875, -1929.07080078125, 112.08055877685547 >, < 0, -86.84, 0 >, < -411.0775451660156, -898.0286254882812, 896.03125 >, < 0, 0, 0 >, < -4008.0947265625, 371.3353271484375, 128.03125 >, < 0, 43.45, 0 > ] )
 printt( "TF1_SWAMP_FASTBALL_REGISTERED", 3 )
 AddCallback_EntitiesDidLoad( TF1SwampFastball_EntitiesLoaded )
}

void function TF1SwampFastball_EntitiesLoaded()
{
 foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
  if ( !( "scriptedPanel" in panel.s ) )
   panel.Destroy()
 TF1SwampFastball_Verify()
}

void function TF1SwampFastball_Verify()
{
 int count = 0
 foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
  if ( "scriptedPanel" in panel.s && "panelId" in panel.s )
  {
   count++
   printt( "TF1_SWAMP_FASTBALL_PANEL", panel.s.panelId, panel.GetOrigin() )
  }
 if ( count != 3 )
  throw "Swampland Fastball requires exactly three consoles"
 printt( "TF1_SWAMP_FASTBALL_PANELS_READY", count )
 NSSaveJSONFile( "swampland_fastball_panels.json", { map = GetMapName(), panels = count } )
}
