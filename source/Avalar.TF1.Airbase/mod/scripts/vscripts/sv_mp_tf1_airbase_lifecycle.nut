global function TF1Port_mp_tf1_airbase_ServerInit
void function TF1Port_mp_tf1_airbase_ServerInit()
{
 if(GetMapName()!="mp_tf1_airbase")return
 if(["tdm", "aitdm", "ps", "mfd", "mfdp", "cp", "ctf", "at"].contains(GAMETYPE))
 {
  ClassicMP_SetLevelIntro(ClassicMP_DefaultDropshipIntro_Setup,DROPSHIP_INTRO_LENGTH)
 }
 else
  ClassicMP_SetLevelIntro(ClassicMP_DefaultNoIntro_Setup,ClassicMP_DefaultNoIntro_GetLength())
 if(!Dev_CommandLineHasParm("-tf1-collision-editor") && ["lts", "ttdm", "tffa", "wlts", "fastball"].contains(GAMETYPE))
  ClassicMP_SetShouldTryIntroAndEpilogueWithoutClassicMP(true)
 ClassicMP_ForceDisableEpilogue(true)
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_airbase_TitanLanding)
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_airbase_OpenTowerRoom)
}

// TF1's intro script opened these doors; without it they seal the room under the tower.
void function TF1Port_mp_tf1_airbase_OpenTowerRoom()
{
 int removed=0
 for(int i=1;i<=6;i++)
 {
  entity door=GetEnt("imc_intro_door_inner"+i)
  if(!IsValid(door))continue
  entity blocker=GetEnt(expect string(door.kv.target))
  if(IsValid(blocker)&&blocker.GetClassName()=="func_brush")
  {
   blocker.Destroy()
   removed++
  }
  door.Destroy()
  removed++
 }
 printt("TF1_AIRBASE_TOWER_ROOM_OPEN",removed)
}

void function TF1Port_mp_tf1_airbase_TitanLanding()
{
 if(!Flag("FlightPath_TitanDrop"))return
 FlightPath flight=GetAnalysisForModel(GetFlightPathModel("fp_titan_model"),HOTDROP_TURBO_ANIM)
 int first=GetAnalysisDataIndex(flight)
 int nodes=GetNodeCount()
 for(int node=0;node<nodes;node++)
  for(int yaw=0;yaw<ANALYSIS_STEPS;yaw++)
   SetNodeScriptData_Boolean(node,first+yaw,false)
 if(first!=16)throw "Unsupported generated Titan flight-analysis layout"
 string settings=""
 foreach(string candidate in GetAllowedPlayerTitanSettings())
 {
  if(!ModelIsPrecached(GetPlayerSettingsAssetForClassName(candidate,"bodymodel")))continue
  settings=candidate
  break
 }
 if(settings=="")throw "No precached Titan for collision analysis"
 entity probe=CreateNPCTitanFromSettings(settings,TEAM_IMC,<0,0,0>,<0,0,0>)
 level.ainTestTitan <- probe
 int accepted=0
 int headings=0
 for(int node=0;node<nodes;node++)
 {
  // Replacement-Titan fallback uses the raw node, not the adjusted analysis origin.
  if(!TitanTestDropPoint(GetNodePos(node),flight))continue
  int passed=NodeAnalysis(flight,node,<0,0,0>)
  if(passed>0)accepted++
  headings+=passed
 }
 probe.Destroy()
 printt("TF1_TITAN_LANDING_REBUILT","mp_tf1_airbase",nodes,accepted,headings,first)
 if(accepted==0)throw "No collision-safe Titan landing nodes"
}
