global function TF1Port_mp_tf1_switchback_ServerInit
void function TF1Port_mp_tf1_switchback_ServerInit()
{
 if(GetMapName()!="mp_tf1_switchback")return

 ClassicMP_ForceDisableEpilogue(true)
 SetRecalculateTitanReplacementPointCallback(TF1Export_ValidatedTitanPoint)
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_switchback_TitanLanding)
}

void function TF1Port_mp_tf1_switchback_TitanLanding()
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
 printt("TF1_TITAN_LANDING_REBUILT","mp_tf1_switchback",nodes,accepted,headings,first)
 if(accepted==0)throw "No collision-safe Titan landing nodes"
}

Point function TF1Export_ValidatedTitanPoint(Point requested,entity player)
{
 FlightPath flight=GetAnalysisForModel(GetFlightPathModel("fp_titan_model"),HOTDROP_TURBO_ANIM)
 int first=GetAnalysisDataIndex(flight)
 int best=-1
 float distance=999999999999.0
 for(int node=0;node<GetNodeCount();node++)
 {
  if(!NodeHasFlightPath(first,node))continue
  vector pos=GetNodePos(node)
  float delta=DistanceSqr(pos,requested.origin)
  if(delta>=distance||!SafeForTitanFall(pos))continue
  best=node
  distance=delta
 }
 if(best<0)throw "No safe Export Titan call location"
 var yaw=GetSpawnPoint_ClosestYaw(best,first,requested.angles.y,360.0)
 if(yaw==null)throw "No valid Export Titan landing heading"
 Point result
 result.origin=GetNodePos(best)
 result.angles=Vector(0,expect float(yaw),0)
 return result
}
