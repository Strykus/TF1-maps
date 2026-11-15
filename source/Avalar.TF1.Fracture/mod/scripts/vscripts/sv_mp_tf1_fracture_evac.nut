global function TF1Evac_mp_tf1_fracture_Init
void function TF1Evac_mp_tf1_fracture_Init()
{
 if ( GetMapName() != "mp_tf1_fracture" ) return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_fracture_Nodes)
}
void function TF1Evac_mp_tf1_fracture_Nodes()
{
 entity node1=GetEnt("endingRescueShip1")
 entity cam1=CreateScriptRef(<5433,2784,280>,< -14,173,0>)
 SetTargetName(cam1,"tf1_evac_cam1")
 node1.kv.target="tf1_evac_cam1"
 AddEvacNode(node1)
 entity node2=GetEnt("endingRescueShip2")
 entity cam2=CreateScriptRef(<6458,-643,512>,< -6,137,0>)
 SetTargetName(cam2,"tf1_evac_cam2")
 node2.kv.target="tf1_evac_cam2"
 AddEvacNode(node2)
 entity node3=GetEnt("endingRescueShip3")
 entity cam3=CreateScriptRef(< -751,-5043,1314>,<0,62,0>)
 SetTargetName(cam3,"tf1_evac_cam3")
 node3.kv.target="tf1_evac_cam3"
 AddEvacNode(node3)
 entity node4=GetEnt("endingRescueShip4")
 entity cam4=CreateScriptRef(< -4131,-6485,673>,<0,57,0>)
 SetTargetName(cam4,"tf1_evac_cam4")
 node4.kv.target="tf1_evac_cam4"
 AddEvacNode(node4)
 entity ref=GetEnt("intro_MCOR_spacenode")
 SetEvacSpaceNode(CreateScriptRef(ref.GetOrigin(),AnglesCompose(ref.GetAngles(), <30,200,20>)))
 print("TF1_EVAC_REGISTERED mp_tf1_fracture 4")
}


