global function TF1Evac_mp_tf1_airbase_Init
void function TF1Evac_mp_tf1_airbase_Init()
{
 if ( GetMapName() != "mp_tf1_airbase" ) return
 bool useEpilogue=!Dev_CommandLineHasParm("-tf1-collision-editor") && ["aitdm","at","cp","ctf","mfd","ps","tdm"].contains(GAMETYPE)
 ClassicMP_ForceDisableEpilogue(!useEpilogue)
 if(!useEpilogue)return
 AddCallback_EntitiesDidLoad(TF1Evac_mp_tf1_airbase_Nodes)
}
void function TF1Evac_mp_tf1_airbase_Nodes()
{
 AddEvacNode(GetEnt("escape_node1"))
 AddEvacNode(GetEnt("escape_node2"))
 AddEvacNode(GetEnt("escape_node3"))
 AddEvacNode(GetEnt("escape_node4"))
 AddEvacNode(GetEnt("escape_node5"))
 SetEvacSpaceNode(CreateScriptRef(< -5714,-982,-7600>,< -3.62,90.307,0>))
 print("TF1_EVAC_REGISTERED mp_tf1_airbase 5")
}

