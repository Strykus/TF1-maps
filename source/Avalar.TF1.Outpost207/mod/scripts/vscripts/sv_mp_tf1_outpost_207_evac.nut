global function TF1Evac_mp_tf1_outpost_207_Init
void function TF1Evac_mp_tf1_outpost_207_Init()
{
 if(GetMapName()!="mp_tf1_outpost_207")return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_outpost_207_Nodes)
}
void function TF1Evac_mp_tf1_outpost_207_Nodes()
{
 entity anchor0=GetEnt("evacNode_1")
 if(!IsValid(anchor0))
 {
  anchor0=CreateEntity("info_target")
  anchor0.SetOrigin(< 2577, -2253, -370 >)
  anchor0.SetAngles(< 0, 305, 0 >)
  anchor0.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor0)
  SetTargetName(anchor0,"evacNode_1")
  anchor0.DisableHibernation()
 }
 anchor0.kv.target="evacNode_1_spectator"
 entity anchor1=GetEnt("evacNode_1_spectator")
 if(!IsValid(anchor1))
 {
  anchor1=CreateEntity("info_target")
  anchor1.SetOrigin(< 3816, 2630, 842 >)
  anchor1.SetAngles(< 2, -113, 0 >)
  anchor1.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor1)
  SetTargetName(anchor1,"evacNode_1_spectator")
  anchor1.DisableHibernation()
 }
 entity anchor2=GetEnt("evacNode_2")
 if(!IsValid(anchor2))
 {
  anchor2=CreateEntity("info_target")
  anchor2.SetOrigin(< -2225, -1352, -120 >)
  anchor2.SetAngles(< 0, -50, 0 >)
  anchor2.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor2)
  SetTargetName(anchor2,"evacNode_2")
  anchor2.DisableHibernation()
 }
 anchor2.kv.target="evacNode_2_spectator"
 entity anchor3=GetEnt("evacNode_2_spectator")
 if(!IsValid(anchor3))
 {
  anchor3=CreateEntity("info_target")
  anchor3.SetOrigin(< -3086, 285, -131.5 >)
  anchor3.SetAngles(< -18, -44.5, 0 >)
  anchor3.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor3)
  SetTargetName(anchor3,"evacNode_2_spectator")
  anchor3.DisableHibernation()
 }
 entity anchor4=GetEnt("evacNode_3")
 if(!IsValid(anchor4))
 {
  anchor4=CreateEntity("info_target")
  anchor4.SetOrigin(< 1221, 2600, 350 >)
  anchor4.SetAngles(< 0, 90, 0 >)
  anchor4.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor4)
  SetTargetName(anchor4,"evacNode_3")
  anchor4.DisableHibernation()
 }
 anchor4.kv.target="evacNode_3_spectator"
 entity anchor5=GetEnt("evacNode_3_spectator")
 if(!IsValid(anchor5))
 {
  anchor5=CreateEntity("info_target")
  anchor5.SetOrigin(< 1459, 4956, -71 >)
  anchor5.SetAngles(< -11, -89, 0 >)
  anchor5.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor5)
  SetTargetName(anchor5,"evacNode_3_spectator")
  anchor5.DisableHibernation()
 }
 entity anchor6=GetEnt("evacSpaceNode")
 if(!IsValid(anchor6))
 {
  anchor6=CreateEntity("info_target")
  anchor6.SetOrigin(< 4200, -14420, -11400 >)
  anchor6.SetAngles(< 0, 0, 0 >)
  anchor6.kv.spawnflags=SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
  DispatchSpawn(anchor6)
  SetTargetName(anchor6,"evacSpaceNode")
  anchor6.DisableHibernation()
 }
 AddEvacNode(GetEnt("evacNode_1"))
 AddEvacNode(GetEnt("evacNode_2"))
 AddEvacNode(GetEnt("evacNode_3"))
 SetEvacSpaceNode(GetEnt("evacSpaceNode"))
 print("TF1_EVAC_REGISTERED mp_tf1_outpost_207 3")
}
