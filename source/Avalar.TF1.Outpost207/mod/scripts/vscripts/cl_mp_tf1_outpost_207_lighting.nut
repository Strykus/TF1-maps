global function TF1Port_mp_tf1_outpost_207_Init
global function TF1Port_mp_tf1_outpost_207_Shutdown
struct
{
 bool active=false
 float sky
 float sun
} file
void function TF1Port_mp_tf1_outpost_207_Init(){if(GetMapName()!="mp_tf1_outpost_207")return;if(!file.active){file.sky=GetConVarFloat("mat_sky_scale");file.sun=GetConVarFloat("mat_sun_scale");}
SetConVarFloat("mat_sky_scale",1.0);SetConVarFloat("mat_sun_scale",0.5);file.active=true;printt("TF1_OUTPOST_SUN_SCALE",GetConVarFloat("mat_sun_scale"));}
void function TF1Port_mp_tf1_outpost_207_Shutdown(){if(!file.active)return;SetConVarFloat("mat_sky_scale",file.sky);SetConVarFloat("mat_sun_scale",file.sun);file.active=false;}
