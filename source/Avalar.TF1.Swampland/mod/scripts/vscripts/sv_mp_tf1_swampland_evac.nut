global function TF1Evac_mp_tf1_swampland_Init
void function TF1Evac_mp_tf1_swampland_Init()
{
 if(GetMapName()!="mp_tf1_swampland")return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_swampland_Nodes)
}
void function TF1Evac_mp_tf1_swampland_Nodes()
{
 entity anchor0=GetEnt("evac_location1")
 if(!IsValid(anchor0))
 {
  anchor0=CreateEntity("info_target")
  anchor0.SetOrigin(< -5164.47, -1796.29, 365 >)
  anchor0.SetAngles(< -0, -130.598, 0 >)
  anchor0.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor0)
  SetTargetName(anchor0,"evac_location1")
  anchor0.DisableHibernation()
 }
 anchor0.kv.target="spec_cam1"
 entity anchor1=GetEnt("spec_cam1")
 if(!IsValid(anchor1))
 {
  anchor1=CreateEntity("info_target")
  anchor1.SetOrigin(< -5680.79, -2125.69, 632.98 >)
  anchor1.SetAngles(< 19.8115, 36.5182, -1.26388e-15 >)
  anchor1.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor1)
  SetTargetName(anchor1,"spec_cam1")
  anchor1.DisableHibernation()
 }
 entity anchor2=GetEnt("evac_location2")
 if(!IsValid(anchor2))
 {
  anchor2=CreateEntity("info_target")
  anchor2.SetOrigin(< -2915.01, -3870.51, 289.625 >)
  anchor2.SetAngles(< -0, -117.681, 0 >)
  anchor2.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor2)
  SetTargetName(anchor2,"evac_location2")
  anchor2.DisableHibernation()
 }
 anchor2.kv.target="spec_cam2"
 entity anchor3=GetEnt("spec_cam2")
 if(!IsValid(anchor3))
 {
  anchor3=CreateEntity("info_target")
  anchor3.SetOrigin(< -4031.53, -3518.9, 438 >)
  anchor3.SetAngles(< -4.78349, 4.1929, 2.93587e-16 >)
  anchor3.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor3)
  SetTargetName(anchor3,"spec_cam2")
  anchor3.DisableHibernation()
 }
 entity anchor4=GetEnt("evac_location4")
 if(!IsValid(anchor4))
 {
  anchor4=CreateEntity("info_target")
  anchor4.SetOrigin(< -2032.1, -1139.19, 587.625 >)
  anchor4.SetAngles(< -0, -154.041, 0 >)
  anchor4.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor4)
  SetTargetName(anchor4,"evac_location4")
  anchor4.DisableHibernation()
 }
 anchor4.kv.target="spec_cam4"
 entity anchor5=GetEnt("spec_cam4")
 if(!IsValid(anchor5))
 {
  anchor5=CreateEntity("info_target")
  anchor5.SetOrigin(< -2564.82, 19.225, 47.105 >)
  anchor5.SetAngles(< -17.7533, -66, 1.12326e-15 >)
  anchor5.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor5)
  SetTargetName(anchor5,"spec_cam4")
  anchor5.DisableHibernation()
 }
 entity anchor6=GetEnt("spacenode")
 if(!IsValid(anchor6))
 {
  anchor6=CreateEntity("info_target")
  anchor6.SetOrigin(< 9600, -1376, -7936 >)
  anchor6.SetAngles(< -0, 69.8056, 0 >)
  anchor6.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor6)
  SetTargetName(anchor6,"spacenode")
  anchor6.DisableHibernation()
 }
 AddEvacNode(GetEnt("evac_location1"))
 AddEvacNode(GetEnt("evac_location2"))
 AddEvacNode(GetEnt("evac_location4"))
 SetEvacSpaceNode(GetEnt("spacenode"))
 print("TF1_EVAC_REGISTERED mp_tf1_swampland 3")
}
