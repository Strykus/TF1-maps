global function TF1OutpostEditor_EnvironmentInit

void function TF1OutpostEditor_EnvironmentInit()
{
 if (GetMapName() != "mp_tf1_outpost_207") return
 ClassicMP_ForceDisableEpilogue(true)
 TF1Port_mp_tf1_outpost_207_Visuals_Init()
 printt("TF1_OUTPOST_EDITOR_ENVIRONMENT_READY")
}

void function TF1Port_mp_tf1_outpost_207_Visuals_Init()
{
 PrecacheModel($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl")
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_outpost_207_Visuals_Spawn)
}
void function TF1Port_mp_tf1_outpost_207_Visuals_Spawn()
{
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(-1044.000000,-548.000000,-180.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(-1044.000000,-548.000000,-180.000000),Vector(-0.000000,-90.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_0")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(748.000000,-924.000000,44.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(748.000000,-924.000000,44.000000),Vector(-0.000000,90.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_1")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(1616.000000,2208.000000,-128.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(1616.000000,2208.000000,-128.000000),Vector(-0.000000,180.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_2")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(128.000000,1772.000000,-192.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(128.000000,1772.000000,-192.000000),Vector(-0.000000,-90.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_3")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(384.000000,1772.000000,-192.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(384.000000,1772.000000,-192.000000),Vector(-0.000000,-90.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_4")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(744.000000,2164.000000,-192.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(744.000000,2164.000000,-192.000000),Vector(-0.000000,0.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_5")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(1824.000000,2304.000000,-196.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(1824.000000,2304.000000,-196.000000),Vector(-0.000000,90.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_6")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(-326.000000,3528.000000,60.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(-326.000000,3528.000000,60.000000),Vector(-0.000000,0.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_7")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
 {
  bool exists=false
  foreach(entity prop in GetEntArrayByClass_Expensive("prop_dynamic"))
   if(prop.GetModelName()==$"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl"&&Distance(prop.GetOrigin(),Vector(-326.000000,3166.000000,60.000000))<1)
   {
    exists=true
    thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
    printt("TF1_DYNAMIC_VISUAL_ANIMATED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
   }
  if(!exists)
  {
   entity prop=CreatePropDynamic($"models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",Vector(-326.000000,3166.000000,60.000000),Vector(-0.000000,0.000000,0.000000),0)
   prop.SetScriptName("TF1Port_mp_tf1_outpost_207_Visuals_8")
   thread TF1Port_mp_tf1_outpost_207_Visuals_Loop(prop,"fast_spin")
   printt("TF1_DYNAMIC_VISUAL_RESTORED","models/imc_base/imc_fan_large_01_animated_tf1outpos.mdl",prop.GetOrigin())
  }
 }
}
void function TF1Port_mp_tf1_outpost_207_Visuals_Loop(entity prop,string animation)
{
 prop.EndSignal("OnDestroy")
 while(IsValid(prop))
 {
  prop.Anim_Play(animation)
  wait max(.1,prop.GetSequenceDuration(animation))
 }
}
