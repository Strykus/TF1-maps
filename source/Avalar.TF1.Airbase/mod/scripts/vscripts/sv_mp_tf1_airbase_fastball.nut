untyped
global function TF1AirbaseFastball_Init

void function TF1AirbaseFastball_Init()
{
 if ( GetMapName() != "mp_tf1_airbase" || GameRules_GetGameMode() != "fastball" )
  return

 ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP( true )
 FastballAddPanelSpawnsForLevel( GetMapName(), [ < -296.490295, -1641.90259, 630.03125 >, < 0, -118.22, 0 >, < 2540.94092, -212.190353, 664.03125 >, < 0, -177.7, 0 >, < -3800.76636, -497.792053, 96.03125 >, < 0, 93.4, 0 > ] )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_IMC, < 728.890015, 2956.45996, 96.03125 >, < 0, -90, 0 > )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_MILITIA, < -1984.89001, -3716.45996, 96.03125 >, < 0, 90, 0 > )
 AddCallback_EntitiesDidLoad( TF1AirbaseFastball_EntitiesLoaded )
}

void function TF1AirbaseFastball_EntitiesLoaded()
{
 int count = 0
 foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
 {
  if ( !( "panelId" in panel.s ) )
  {
   panel.Destroy()
   continue
  }
  count++
  printt( "TF1_AIRBASE_FASTBALL_PANEL", panel.s.panelId, panel.GetOrigin() )
 }
 printt( "TF1_AIRBASE_FASTBALL_PANELS_READY", count )
}
