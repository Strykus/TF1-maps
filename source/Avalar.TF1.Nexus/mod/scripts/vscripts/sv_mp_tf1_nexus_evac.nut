global function TF1Evac_mp_tf1_nexus_Init
void function TF1Evac_mp_tf1_nexus_Init()
{
 if(GetMapName()!="mp_tf1_nexus")return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_nexus_Nodes)
}
void function TF1Evac_mp_tf1_nexus_Nodes()
{
 entity anchor0=GetEnt("escape_node1")
 if(!IsValid(anchor0))
 {
  anchor0=CreateEntity("info_target")
  anchor0.SetOrigin(< 1592, -1088, 976 >)
  anchor0.SetAngles(< -0, 1.012, 0 >)
  anchor0.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor0)
  SetTargetName(anchor0,"escape_node1")
  anchor0.DisableHibernation()
 }
 anchor0.kv.target="spec_cam1"
 entity anchor1=GetEnt("spec_cam1")
 if(!IsValid(anchor1))
 {
  anchor1=CreateEntity("info_target")
  anchor1.SetOrigin(< -64, 360, 2232 >)
  anchor1.SetAngles(< 24.5617, -46.804, -2.34213 >)
  anchor1.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor1)
  SetTargetName(anchor1,"spec_cam1")
  anchor1.DisableHibernation()
 }
 entity anchor2=GetEnt("escape_node2")
 if(!IsValid(anchor2))
 {
  anchor2=CreateEntity("info_target")
  anchor2.SetOrigin(< -1968, 1616, 1112 >)
  anchor2.SetAngles(< -0, -88.988, 0 >)
  anchor2.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor2)
  SetTargetName(anchor2,"escape_node2")
  anchor2.DisableHibernation()
 }
 anchor2.kv.target="spec_cam2"
 entity anchor3=GetEnt("spec_cam2")
 if(!IsValid(anchor3))
 {
  anchor3=CreateEntity("info_target")
  anchor3.SetOrigin(< 88, 2720, 1632 >)
  anchor3.SetAngles(< 16.3986, -151.801, -1.77825e-06 >)
  anchor3.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor3)
  SetTargetName(anchor3,"spec_cam2")
  anchor3.DisableHibernation()
 }
 entity anchor4=GetEnt("escape_node3")
 if(!IsValid(anchor4))
 {
  anchor4=CreateEntity("info_target")
  anchor4.SetOrigin(< -1504, -1512, 440 >)
  anchor4.SetAngles(< -0, -88.988, 0 >)
  anchor4.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor4)
  SetTargetName(anchor4,"escape_node3")
  anchor4.DisableHibernation()
 }
 anchor4.kv.target="spec_cam3"
 entity anchor5=GetEnt("spec_cam3")
 if(!IsValid(anchor5))
 {
  anchor5=CreateEntity("info_target")
  anchor5.SetOrigin(< -3200, -2216, 688 >)
  anchor5.SetAngles(< 5.94595, 33.1306, 0.51212 >)
  anchor5.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor5)
  SetTargetName(anchor5,"spec_cam3")
  anchor5.DisableHibernation()
 }
 entity anchor6=GetEnt("spacenode")
 if(!IsValid(anchor6))
 {
  anchor6=CreateEntity("info_target")
  anchor6.SetOrigin(< -64, -64, -4864 >)
  anchor6.SetAngles(< -0, 90, 0 >)
  anchor6.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor6)
  SetTargetName(anchor6,"spacenode")
  anchor6.DisableHibernation()
 }
 AddEvacNode(GetEnt("escape_node1"))
 AddEvacNode(GetEnt("escape_node2"))
 AddEvacNode(GetEnt("escape_node3"))
 SetEvacSpaceNode(GetEnt("spacenode"))
 print("TF1_EVAC_REGISTERED mp_tf1_nexus 3")
}
