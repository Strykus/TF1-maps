untyped
global function TF1FractureFastball_Init

void function TF1FractureFastball_Init()
{
 if ( GetMapName() != "mp_tf1_fracture" || GameRules_GetGameMode() != "fastball" )
  return

 ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP( true )
 FastballAddPanelSpawnsForLevel( GetMapName(), [ < 3117.19702, 2572.41333, -239.96875 >, < 0, 0, 0 >, < 2548.0813, 636.415222, -23.9374218 >, < 0, 0, 0 >, < 2696.63647, -1988.83093, -31.96875 >, < 0, 0, 0 > ] )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_IMC, < -3786.26001, -4324.12988, 124.895638 >, < 0, -8.53219986, 0 > )
 FastballAddBuddySpawnForLevel( GetMapName(), TEAM_MILITIA, < 5491.81006, 2645.52002, -146.023224 >, < 0, -130.292999, 0 > )
 AddCallback_EntitiesDidLoad( TF1FractureFastball_EntitiesLoaded )
}

void function TF1FractureFastball_EntitiesLoaded()
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
  printt( "TF1_FRACTURE_FASTBALL_PANEL", panel.s.panelId, panel.GetOrigin() )
 }
 printt( "TF1_FRACTURE_FASTBALL_PANELS_READY", count )
}
