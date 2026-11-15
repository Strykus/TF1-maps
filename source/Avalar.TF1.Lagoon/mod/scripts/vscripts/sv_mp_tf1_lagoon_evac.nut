global function TF1Evac_mp_tf1_lagoon_Init
void function TF1Evac_mp_tf1_lagoon_Init()
{
 if(GetMapName()!="mp_tf1_lagoon")return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_lagoon_Nodes)
}
void function TF1Evac_mp_tf1_lagoon_Nodes()
{
 entity anchor0=GetEnt("evacBoathouse")
 if(!IsValid(anchor0))
 {
  anchor0=CreateEntity("info_target")
  anchor0.SetOrigin(< -2380.91, 626.571, 724.057 >)
  anchor0.SetAngles(< -0, -90, 0 >)
  anchor0.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor0)
  SetTargetName(anchor0,"evacBoathouse")
  anchor0.DisableHibernation()
 }
 anchor0.kv.target="tf1_evac_spec_1"
 entity anchor1=GetEnt("tf1_evac_spec_1")
 if(!IsValid(anchor1))
 {
  anchor1=CreateEntity("info_target")
  anchor1.SetOrigin(< -2380.91, 1138.571, 980.057 >)
  anchor1.SetAngles(< 26.5650512, -90, 0 >)
  anchor1.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor1)
  SetTargetName(anchor1,"tf1_evac_spec_1")
  anchor1.DisableHibernation()
 }
 entity anchor2=GetEnt("evacOperations")
 if(!IsValid(anchor2))
 {
  anchor2=CreateEntity("info_target")
  anchor2.SetOrigin(< -157.983, 5789.25, 388.465 >)
  anchor2.SetAngles(< -0, 180, 0 >)
  anchor2.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor2)
  SetTargetName(anchor2,"evacOperations")
  anchor2.DisableHibernation()
 }
 anchor2.kv.target="tf1_evac_spec_2"
 entity anchor3=GetEnt("tf1_evac_spec_2")
 if(!IsValid(anchor3))
 {
  anchor3=CreateEntity("info_target")
  anchor3.SetOrigin(< 354.017, 5789.25, 644.465 >)
  anchor3.SetAngles(< 26.5650512, 180, 0 >)
  anchor3.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor3)
  SetTargetName(anchor3,"tf1_evac_spec_2")
  anchor3.DisableHibernation()
 }
 entity anchor4=GetEnt("evacShack")
 if(!IsValid(anchor4))
 {
  anchor4=CreateEntity("info_target")
  anchor4.SetOrigin(< -3069.02, 2457.6, 786.352 >)
  anchor4.SetAngles(< -0, 180, 0 >)
  anchor4.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor4)
  SetTargetName(anchor4,"evacShack")
  anchor4.DisableHibernation()
 }
 anchor4.kv.target="tf1_evac_spec_3"
 entity anchor5=GetEnt("tf1_evac_spec_3")
 if(!IsValid(anchor5))
 {
  anchor5=CreateEntity("info_target")
  anchor5.SetOrigin(< -2557.02, 2457.6, 1042.352 >)
  anchor5.SetAngles(< 26.5650512, 180, 0 >)
  anchor5.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor5)
  SetTargetName(anchor5,"tf1_evac_spec_3")
  anchor5.DisableHibernation()
 }
 entity anchor6=GetEnt("evacOperations1")
 if(!IsValid(anchor6))
 {
  anchor6=CreateEntity("info_target")
  anchor6.SetOrigin(< -913.509, 5116.55, 444.999 >)
  anchor6.SetAngles(< -0, 90, 0 >)
  anchor6.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor6)
  SetTargetName(anchor6,"evacOperations1")
  anchor6.DisableHibernation()
 }
 anchor6.kv.target="tf1_evac_spec_4"
 entity anchor7=GetEnt("tf1_evac_spec_4")
 if(!IsValid(anchor7))
 {
  anchor7=CreateEntity("info_target")
  anchor7.SetOrigin(< -913.509, 4604.55, 700.999 >)
  anchor7.SetAngles(< 26.5650512, 90, 0 >)
  anchor7.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor7)
  SetTargetName(anchor7,"tf1_evac_spec_4")
  anchor7.DisableHibernation()
 }
 entity anchor8=GetEnt("intro_spacenode")
 if(!IsValid(anchor8))
 {
  anchor8=CreateEntity("info_target")
  anchor8.SetOrigin(< -728, -4352, -3604 >)
  anchor8.SetAngles(< -5, 69, 3.06941e-16 >)
  anchor8.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor8)
  SetTargetName(anchor8,"intro_spacenode")
  anchor8.DisableHibernation()
 }
 AddEvacNode(GetEnt("evacBoathouse"))
 AddEvacNode(GetEnt("evacOperations"))
 AddEvacNode(GetEnt("evacShack"))
 AddEvacNode(GetEnt("evacOperations1"))
 SetEvacSpaceNode(GetEnt("intro_spacenode"))
 print("TF1_EVAC_REGISTERED mp_tf1_lagoon 4")
}
