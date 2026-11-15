global function TF1Evac_mp_tf1_overlook_Init
void function TF1Evac_mp_tf1_overlook_Init()
{
 if ( GetMapName() != "mp_tf1_overlook" ) return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_overlook_Nodes)
}
void function TF1Evac_mp_tf1_overlook_Nodes()
{
 entity node1=GetEnt("endingRescueShip1")
 entity cam1=CreateScriptRef(<1023.80,-5324.44,185.07>,< -2.63,144.42,0>)
 SetTargetName(cam1,"tf1_evac_cam1")
 node1.kv.target="tf1_evac_cam1"
 AddEvacNode(node1)
 entity node3=GetEnt("endingRescueShip3")
 entity cam3=CreateScriptRef(<2941.92,1266.42,176.69>,<8.51,37.89,0>)
 SetTargetName(cam3,"tf1_evac_cam3")
 node3.kv.target="tf1_evac_cam3"
 AddEvacNode(node3)
 SetEvacSpaceNode(CreateScriptRef(< -5393.48,-13542.21,-13132.57>,<0,160,0>))
 print("TF1_EVAC_REGISTERED mp_tf1_overlook 2")
}

