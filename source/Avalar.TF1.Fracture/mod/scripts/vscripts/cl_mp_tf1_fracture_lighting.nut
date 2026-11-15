global function TF1Port_mp_tf1_fracture_Init
global function TF1Port_mp_tf1_fracture_Shutdown
struct
{
 bool active=false
 float sky
} file
void function TF1Port_mp_tf1_fracture_Init(){if(GetMapName()!="mp_tf1_fracture")return;file.sky=GetConVarFloat("mat_sky_scale");SetConVarFloat("mat_sky_scale",1.0);file.active=true;}
void function TF1Port_mp_tf1_fracture_Shutdown(){if(!file.active)return;SetConVarFloat("mat_sky_scale",file.sky);file.active=false;}
