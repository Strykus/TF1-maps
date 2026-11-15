global function TF1Evac_mp_tf1_switchback_Init
void function TF1Evac_mp_tf1_switchback_Init()
{
 if(GetMapName()!="mp_tf1_switchback")return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_switchback_Nodes)
}
void function TF1Evac_mp_tf1_switchback_Nodes()
{
 entity anchor0=GetEnt("escape_node1")
 if(!IsValid(anchor0))
 {
  anchor0=CreateEntity("info_target")
  anchor0.SetOrigin(< 600, -944, 632 >)
  anchor0.SetAngles(< -0, -88.988, 0 >)
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
  anchor1.SetOrigin(< 696, -1936, 1072 >)
  anchor1.SetAngles(< 0.996961, 57.2569, -0.441387 >)
  anchor1.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor1)
  SetTargetName(anchor1,"spec_cam1")
  anchor1.DisableHibernation()
 }
 entity anchor2=GetEnt("escape_node2")
 if(!IsValid(anchor2))
 {
  anchor2=CreateEntity("info_target")
  anchor2.SetOrigin(< 1667, 930, 865 >)
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
  anchor3.SetOrigin(< 2576, -48, 1360 >)
  anchor3.SetAngles(< 13.2133, 141.578, -2.29884 >)
  anchor3.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor3)
  SetTargetName(anchor3,"spec_cam2")
  anchor3.DisableHibernation()
 }
 entity anchor4=GetEnt("escape_node3")
 if(!IsValid(anchor4))
 {
  anchor4=CreateEntity("info_target")
  anchor4.SetOrigin(< -968, -1040, 336 >)
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
  anchor5.SetOrigin(< -1816, -2672, 1072 >)
  anchor5.SetAngles(< 13.2133, 63.718, -2.29884 >)
  anchor5.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor5)
  SetTargetName(anchor5,"spec_cam3")
  anchor5.DisableHibernation()
 }
 entity anchor6=GetEnt("escape_node4")
 if(!IsValid(anchor6))
 {
  anchor6=CreateEntity("info_target")
  anchor6.SetOrigin(< -1685, 2200, 1140 >)
  anchor6.SetAngles(< -0, 1.012, 0 >)
  anchor6.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor6)
  SetTargetName(anchor6,"escape_node4")
  anchor6.DisableHibernation()
 }
 anchor6.kv.target="spec_cam4"
 entity anchor7=GetEnt("spec_cam4")
 if(!IsValid(anchor7))
 {
  anchor7=CreateEntity("info_target")
  anchor7.SetOrigin(< -2968, 400, 1856 >)
  anchor7.SetAngles(< 13.2133, 63.718, -2.29884 >)
  anchor7.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor7)
  SetTargetName(anchor7,"spec_cam4")
  anchor7.DisableHibernation()
 }
 entity anchor8=GetEnt("spacenode")
 if(!IsValid(anchor8))
 {
  anchor8=CreateEntity("info_target")
  anchor8.SetOrigin(< -896, -3376, -7152 >)
  anchor8.SetAngles(< -0, 80.4541, 0 >)
  anchor8.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor8)
  SetTargetName(anchor8,"spacenode")
  anchor8.DisableHibernation()
 }
 AddEvacNode(GetEnt("escape_node1"))
 AddEvacNode(GetEnt("escape_node2"))
 AddEvacNode(GetEnt("escape_node3"))
 AddEvacNode(GetEnt("escape_node4"))
 SetEvacSpaceNode(GetEnt("spacenode"))
 print("TF1_EVAC_REGISTERED mp_tf1_switchback 4")
}
