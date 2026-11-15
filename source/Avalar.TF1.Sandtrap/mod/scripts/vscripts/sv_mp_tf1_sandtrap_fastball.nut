untyped
global function TF1SandtrapFastball_Init

void function TF1SandtrapFastball_Init()
{
 if ( GetMapName() != "mp_tf1_sandtrap" || GameRules_GetGameMode() != "fastball" )
  return

 ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP( true )
 FastballAddPanelSpawnsForLevel( GetMapName(), [ < -2784.84814, -3771.57104, 0.03125 >, < 0, -88.96, 0 >, < -1078.35779, -1776.36438, -287.217957 >, < 0, 178.69, 0 >, < 627.477295, 315.758118, 256.03125 >, < 0, 90.35, 0 > ] )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_IMC, < -390.092987, -5923.72021, -82.8216858 >, < 0, 77.2564011, 0 > )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_MILITIA, < -2182.45996, 2612.37988, 41.0611801 >, < 0, -97.987999, 0 > )
 AddCallback_EntitiesDidLoad( TF1SandtrapFastball_EntitiesLoaded )
}

void function TF1SandtrapFastball_EntitiesLoaded()
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
  printt( "TF1_SANDTRAP_FASTBALL_PANEL", panel.s.panelId, panel.GetOrigin() )
 }
 printt( "TF1_SANDTRAP_FASTBALL_PANELS_READY", count )
}
