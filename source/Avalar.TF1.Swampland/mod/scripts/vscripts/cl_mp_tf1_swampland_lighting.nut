global function TF1Port_mp_tf1_swampland_Init
global function TF1Port_mp_tf1_swampland_Shutdown
struct
{
 bool active=false
 float sky
} file
void function TF1Port_mp_tf1_swampland_Init(){if(GetMapName()!="mp_tf1_swampland")return;file.sky=GetConVarFloat("mat_sky_scale");SetConVarFloat("mat_sky_scale",1.0);file.active=true;}
void function TF1Port_mp_tf1_swampland_Shutdown(){if(!file.active)return;SetConVarFloat("mat_sky_scale",file.sky);file.active=false;}
