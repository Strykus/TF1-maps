global function TF1Port_mp_tf1_sandtrap_ServerInit
void function TF1Port_mp_tf1_sandtrap_ServerInit()
{
 if(GetMapName()!="mp_tf1_sandtrap")return
 bool editor=Dev_CommandLineHasParm("-tf1-collision-editor")
 if(!editor && ["tdm", "aitdm", "ps", "mfd", "mfdp", "cp", "ctf", "at"].contains(GAMETYPE))
  ClassicMP_SetLevelIntro(ClassicMP_DefaultDropshipIntro_Setup,DROPSHIP_INTRO_LENGTH)
 else
  ClassicMP_SetLevelIntro(ClassicMP_DefaultNoIntro_Setup,ClassicMP_DefaultNoIntro_GetLength())

 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(useEpilogue)
  AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_sandtrap_EvacNodes)
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_sandtrap_TitanLanding)
}

void function TF1Port_mp_tf1_sandtrap_TitanLanding()
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
 printt("TF1_TITAN_LANDING_REBUILT","mp_tf1_sandtrap",nodes,accepted,headings,first)
 if(accepted==0)throw "No collision-safe Titan landing nodes"
}

void function TF1Port_mp_tf1_sandtrap_EvacNodes()
{
 for(int i=1;i<=3;i++)
 {
  string suffix=i.tostring()
  entity node=GetEnt("evac_location"+suffix)
  node.kv.target="spec_cam"+suffix
  AddEvacNode(node)
 }
 SetEvacSpaceNode(GetEnt("spacenode"))
 print("TF1_EVAC_REGISTERED mp_tf1_sandtrap 3")
}
