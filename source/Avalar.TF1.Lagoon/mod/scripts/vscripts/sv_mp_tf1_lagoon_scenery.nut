global function TF1Port_mp_tf1_lagoon_Scenery_Precache
global function TF1Port_mp_tf1_lagoon_Scenery_Init
void function TF1Port_mp_tf1_lagoon_Scenery_Precache()
{
 if(GetMapName()!="mp_tf1_lagoon")return
 PrecacheModel($"models/vehicle/straton/straton_imc_gunship_01.mdl")
}
void function TF1Port_mp_tf1_lagoon_Scenery_Init()
{
 if(GetMapName()!="mp_tf1_lagoon")return
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_lagoon_Scenery_Spawn)
}
void function TF1Port_mp_tf1_lagoon_Scenery_Spawn()
{
 array<vector> positions=[Vector(-3416.889892578125,5014.35986328125,1124.0),Vector(1412.0,5900.0,454.0)]
 array<vector> angles=[Vector(0,62.135398864746094,0),Vector(0,140.8520050048828,0)]
 foreach(int i,vector position in positions)
 {
  entity visual=CreatePropDynamic($"models/vehicle/straton/straton_imc_gunship_01.mdl",position,angles[i],0)
  visual.SetScriptName("TF1_PORT_AIRCRAFT_"+i)
 }
 printt("TF1_SCENERY_AIRCRAFT_READY",positions.len())
}
