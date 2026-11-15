global function TF1Port_mp_tf1_outpost_207_StoryClient_Init
global function ServerCallback_TF1OutpostConversation
global function ServerCallback_TF1OutpostOutcome
global function ServerCallback_TF1OutpostWarpArrival
global function ServerCallback_TF1Story_Stage
global function ServerCallback_TF1Story_Decoy
global function ServerCallback_TF1Story_Prepare

entity TF1Port_mp_tf1_outpost_207_ship
int TF1Port_mp_tf1_outpost_207_driftToken
int TF1Port_mp_tf1_outpost_207_reactToken
array<entity> TF1Port_mp_tf1_outpost_207_skyBases
array<entity> TF1Port_mp_tf1_outpost_207_skyBarrels
array<vector> TF1Port_mp_tf1_outpost_207_skyAngs
array<vector> TF1Port_mp_tf1_outpost_207_skyRest

// What TF2 does for its own skybox ships (cl_carrier.gnut): client-side prop, long fade distance, always rendered.
entity function TF1Port_mp_tf1_outpost_207_SkyProp(asset model,vector origin,vector angles)
{
 entity prop = CreatePropDynamic(model,origin,angles)
 prop.SetFadeDistance(36000)
 prop.EnableRenderAlways()
 return prop
}

// Skybox cannons: TF1 aims them along (cannon - skybox position of the target).
vector function TF1Port_mp_tf1_outpost_207_SkyAimAngles(int i,vector worldPos)
{
 vector dir = Normalize(worldPos)
 vector skyPos = Vector(11904.0,11904.0,-11776.0) + dir * (Distance(worldPos,Vector(0,0,0)) / 1000.0)
 return VectorToAngles(Normalize(TF1Port_mp_tf1_outpost_207_skyBases[i].GetOrigin() - skyPos))
}

void function TF1Port_mp_tf1_outpost_207_SkyCannonRotate(int i,vector toAng,float seconds)
{
 entity base = TF1Port_mp_tf1_outpost_207_skyBases[i]
 entity barrel = TF1Port_mp_tf1_outpost_207_skyBarrels[i]
 vector from = TF1Port_mp_tf1_outpost_207_skyAngs[i]
 float start = Time()
 while(IsValid(base) && IsValid(barrel))
 {
  float f = (Time() - start) / seconds
  if(f > 1.0)
   f = 1.0
  float s = f * f * (3.0 - 2.0 * f)
  vector a = Vector(from.x + TF1Port_mp_tf1_outpost_207_AngleDelta(from.x,toAng.x) * s,from.y + TF1Port_mp_tf1_outpost_207_AngleDelta(from.y,toAng.y) * s,0)
  base.SetAngles(Vector(0,a.y,0))
  barrel.SetAngles(a)
  barrel.SetOrigin(base.GetAttachmentOrigin(base.LookupAttachment("barrel_attachment")))
  TF1Port_mp_tf1_outpost_207_skyAngs[i] = a
  if(f >= 1.0)
   break
  WaitFrame()
 }
}

void function TF1Port_mp_tf1_outpost_207_SkyCannonFx(int i,string kind,vector skyEnd)
{
 entity barrel = TF1Port_mp_tf1_outpost_207_skyBarrels[i]
 if(!IsValid(barrel))
  return
 int attach = barrel.LookupAttachment("rail_flap_01")
 int fx = 0
 if(kind == "prefire")
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_rail_charge_SB_1")
 else if(kind == "flash")
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_rail_fire_flash_SB")
 else
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_rail_fire_beam_scale_SB")
 printt("TF1_SKY_FX",kind,i,attach,fx)
 if(attach <= 0 || fx == 0)
  return
 int handle = StartParticleEffectOnEntity(barrel,fx,FX_PATTACH_POINT_FOLLOW,attach)
 if(kind == "beam")
  EffectSetControlPointVector(handle,1,skyEnd)
}

vector function TF1Port_mp_tf1_outpost_207_SkyBeamEnd(int i,vector worldPos)
{
 entity barrel = TF1Port_mp_tf1_outpost_207_skyBarrels[i]
 vector skyPos = Vector(11904.0,11904.0,-11776.0) + Normalize(worldPos) * (Distance(worldPos,Vector(0,0,0)) / 1000.0)
 vector attachOrg = barrel.GetAttachmentOrigin(barrel.LookupAttachment("rail_flap_01"))
 vector dir = Normalize(skyPos - attachOrg)
 return attachOrg + dir * Distance(Vector(11904.0,11904.0,-11776.0),attachOrg)
}

void function TF1Port_mp_tf1_outpost_207_DecoySky()
{
 vector target = Vector(-103.1,-12779.8,4500.0)
 wait 3.7
 for(int i = 0; i < 2 && i < TF1Port_mp_tf1_outpost_207_skyBases.len(); i++)
  thread TF1Port_mp_tf1_outpost_207_SkyCannonRotate(i,TF1Port_mp_tf1_outpost_207_SkyAimAngles(i,target),10.89)
 // TF1: prefire effect 3.8 s before the 12.1 s mark, then muzzle flash and beam
 wait 8.3
 for(int i = 0; i < 2 && i < TF1Port_mp_tf1_outpost_207_skyBases.len(); i++)
  TF1Port_mp_tf1_outpost_207_SkyCannonFx(i,"prefire",target)
 wait 3.8
 for(int i = 0; i < 2 && i < TF1Port_mp_tf1_outpost_207_skyBases.len(); i++)
 {
  TF1Port_mp_tf1_outpost_207_SkyCannonFx(i,"flash",target)
  TF1Port_mp_tf1_outpost_207_SkyCannonFx(i,"beam",TF1Port_mp_tf1_outpost_207_SkyBeamEnd(i,target))
 }
 wait 4.0
 for(int i = 0; i < 2 && i < TF1Port_mp_tf1_outpost_207_skyBases.len(); i++)
  thread TF1Port_mp_tf1_outpost_207_SkyCannonRotate(i,TF1Port_mp_tf1_outpost_207_skyRest[i],11.0)
}

void function TF1Port_mp_tf1_outpost_207_DecoyRun()
{
 wait 2.9
 vector startOrg = Vector(11894.50000,11887.80000,-11771.50000)
 vector endOrg = Vector(11903.89693,11891.22020,-11771.50000)
 entity decoy = TF1Port_mp_tf1_outpost_207_SkyProp($"models/vehicle/capital_ship_birmingham/birmingham_decoy_sky_tf1outpos.mdl",startOrg,Vector(0,20.0,0))
 // Entity render color turned the hull black even at 170, so the brightness is set in the material ($color2) instead
 // Invisible world-scale twin: its animation events spawn the TF1 effects and debris at their real size
 vector worldStart = Vector(-9500.0,-16200.0,4500.0)
 vector worldEnd = Vector(-103.1,-12779.8,4500.0)
 entity twin = CreatePropDynamic($"models/vehicle/capital_ship_birmingham/birmingham_decoy_ghost_tf1outpos.mdl",worldStart,Vector(0,20.0,0))
 twin.SetFadeDistance(90000)
 twin.EnableRenderAlways()
 float start = Time()
 while(IsValid(decoy))
 {
  float f = (Time() - start) / 13.0
  if(f >= 1.0)
   break
  decoy.SetOrigin(startOrg + (endOrg - startOrg) * f)
  if(IsValid(twin))
   twin.SetOrigin(worldStart + (worldEnd - worldStart) * f)
  WaitFrame()
 }
 if(IsValid(decoy))
 {
  // TF1 plays ds_outpost_destroyed (1001 frames at 30 fps) after the flight; the duration is fixed because GetSequenceDuration is unsafe on converted models
  decoy.Anim_Play("ds_outpost_destroyed")
  if(IsValid(twin))
   twin.Anim_Play("ds_outpost_destroyed")
  printt("TF1_DECOY_CRASH_ANIM",decoy.LookupSequence("ds_outpost_destroyed"),Time())
  // Anim_Play does not apply root motion on a client prop, so the TF1 frame movement is replayed here
  array<vector> path = [Vector(0.00000,0.00000,0.00000),Vector(-0.01730,0.05270,-0.02740),Vector(-0.03030,0.10520,-0.06240),Vector(-0.03930,0.15780,-0.10460),Vector(-0.04450,0.21030,-0.15490),Vector(-0.04580,0.26250,-0.21190),Vector(-0.04330,0.31470,-0.27620),Vector(-0.03720,0.36710,-0.34710),Vector(-0.02760,0.41930,-0.42520),Vector(-0.01440,0.47170,-0.50960),Vector(0.00200,0.52410,-0.60030),Vector(0.02180,0.57690,-0.69780),Vector(0.04500,0.62940,-0.80150),Vector(0.07110,0.68230,-0.91110),Vector(0.10050,0.73540,-1.02650),Vector(0.13260,0.78900,-1.14770),Vector(0.16780,0.84250,-1.27480),Vector(0.20550,0.89640,-1.40720),Vector(0.24620,0.95080,-1.54510),Vector(0.28930,1.00530,-1.68790),Vector(0.33510,1.06040,-1.83610),Vector(0.38320,1.11610,-1.98870),Vector(0.43360,1.17200,-2.14680),Vector(0.48630,1.22850,-2.30890),Vector(0.54110,1.28550,-2.47550),Vector(0.59810,1.34300,-2.64660),Vector(0.65700,1.40120,-2.82210),Vector(0.71800,1.45990,-3.00130),Vector(0.78070,1.51940,-3.18450),Vector(0.84510,1.57960,-3.37170),Vector(0.91110,1.64040,-3.56210),Vector(0.97880,1.70210,-3.75610),Vector(1.04790,1.76460,-3.95370),Vector(1.11820,1.82770,-4.15390),Vector(1.19000,1.89180,-4.35780),Vector(1.26320,1.95680,-4.56440),Vector(1.33730,2.02260,-4.77360),Vector(1.41220,2.08940,-4.98510),Vector(1.48840,2.15730,-5.19970),Vector(1.56530,2.22610,-5.41620),Vector(1.64290,2.29590,-5.63480),Vector(1.72130,2.36690,-5.85580),Vector(1.80010,2.43890,-6.07850),Vector(1.87980,2.51200,-6.30250),Vector(1.95960,2.58640,-6.52880),Vector(2.03960,2.66190,-6.75610),Vector(2.12020,2.73880,-6.98510),Vector(2.20070,2.81690,-7.21500),Vector(2.28150,2.89610,-7.44580),Vector(2.36210,2.97680,-7.67750),Vector(2.44270,3.05880,-7.91050),Vector(2.52300,3.14210,-8.14350),Vector(2.60290,3.22700,-8.37700),Vector(2.68270,3.31340,-8.61100),Vector(2.76180,3.40110,-8.84490),Vector(2.84050,3.49050,-9.07890),Vector(2.91850,3.58120,-9.31280),Vector(2.99580,3.67380,-9.54630),Vector(3.07230,3.76770,-9.77980),Vector(3.14790,3.86330,-10.01240),Vector(3.22240,3.96080,-10.24410),Vector(3.29610,4.06000,-10.47530),Vector(3.36840,4.16060,-10.70520),Vector(3.43960,4.26320,-10.93420),Vector(3.50940,4.36750,-11.16190),Vector(3.57780,4.47390,-11.38820),Vector(3.64450,4.58190,-11.61270),Vector(3.70970,4.69200,-11.83540),Vector(3.77340,4.80380,-12.05680),Vector(3.83520,4.91770,-12.27550),Vector(3.89510,5.03350,-12.49280),Vector(3.95310,5.15150,-12.70750),Vector(4.00910,5.27160,-12.91940),Vector(4.06290,5.39370,-13.12910),Vector(4.11450,5.51790,-13.33560),Vector(4.16370,5.64410,-13.54000),Vector(4.21080,5.77260,-13.74070),Vector(4.25520,5.90360,-13.93870),Vector(4.29700,6.03650,-14.13310),Vector(4.33630,6.17180,-14.32400),Vector(4.37270,6.30930,-14.51160),Vector(4.40640,6.44920,-14.69530),Vector(4.37020,6.57190,-14.71370),Vector(4.32190,6.70450,-14.71370),Vector(4.26910,6.84910,-14.71370),Vector(4.21210,7.00550,-14.71370),Vector(4.15100,7.17360,-14.71370),Vector(4.08610,7.35190,-14.71370),Vector(4.01740,7.54060,-14.71370),Vector(3.94510,7.73910,-14.71370),Vector(3.86980,7.94670,-14.71370),Vector(3.79090,8.16300,-14.71370),Vector(3.70920,8.38740,-14.71370),Vector(3.62470,8.61960,-14.71370),Vector(3.53760,8.85880,-14.71370),Vector(3.44820,9.10490,-14.71370),Vector(3.35640,9.35660,-14.71370),Vector(3.26260,9.61450,-14.71370),Vector(3.16690,9.87740,-14.71370),Vector(3.06960,10.14450,-14.71370),Vector(2.97090,10.41630,-14.71370)]
  array<vector> wpath = [Vector(0.0,0.0,0.0),Vector(-17.3,52.7,-27.4),Vector(-30.3,105.2,-62.4),Vector(-39.3,157.8,-104.6),Vector(-44.5,210.3,-154.9),Vector(-45.8,262.5,-211.9),Vector(-43.3,314.7,-276.2),Vector(-37.2,367.1,-347.1),Vector(-27.6,419.3,-425.2),Vector(-14.4,471.7,-509.6),Vector(2.0,524.1,-600.3),Vector(21.8,576.9,-697.8),Vector(45.0,629.4,-801.5),Vector(71.1,682.3,-911.1),Vector(100.5,735.4,-1026.5),Vector(132.6,789.0,-1147.7),Vector(167.8,842.5,-1274.8),Vector(205.5,896.4,-1407.2),Vector(246.2,950.8,-1545.1),Vector(289.3,1005.3,-1687.9),Vector(335.1,1060.4,-1836.1),Vector(383.2,1116.1,-1988.7),Vector(433.6,1172.0,-2146.8),Vector(486.3,1228.5,-2308.9),Vector(541.1,1285.5,-2475.5),Vector(598.1,1343.0,-2646.6),Vector(657.0,1401.2,-2822.1),Vector(718.0,1459.9,-3001.3),Vector(780.7,1519.4,-3184.5),Vector(845.1,1579.6,-3371.7),Vector(911.1,1640.4,-3562.1),Vector(978.8,1702.1,-3756.1),Vector(1047.9,1764.6,-3953.7),Vector(1118.2,1827.7,-4153.9),Vector(1190.0,1891.8,-4357.8),Vector(1263.2,1956.8,-4564.4),Vector(1337.3,2022.6,-4773.6),Vector(1412.2,2089.4,-4985.1),Vector(1488.4,2157.3,-5199.7),Vector(1565.3,2226.1,-5416.2),Vector(1642.9,2295.9,-5634.8),Vector(1721.3,2366.9,-5855.8),Vector(1800.1,2438.9,-6078.5),Vector(1879.8,2512.0,-6302.5),Vector(1959.6,2586.4,-6528.8),Vector(2039.6,2661.9,-6756.1),Vector(2120.2,2738.8,-6985.1),Vector(2200.7,2816.9,-7215.0),Vector(2281.5,2896.1,-7445.8),Vector(2362.1,2976.8,-7677.5),Vector(2442.7,3058.8,-7910.5),Vector(2523.0,3142.1,-8143.5),Vector(2602.9,3227.0,-8377.0),Vector(2682.7,3313.4,-8611.0),Vector(2761.8,3401.1,-8844.9),Vector(2840.5,3490.5,-9078.9),Vector(2918.5,3581.2,-9312.8),Vector(2995.8,3673.8,-9546.3),Vector(3072.3,3767.7,-9779.8),Vector(3147.9,3863.3,-10012.4),Vector(3222.4,3960.8,-10244.1),Vector(3296.1,4060.0,-10475.3),Vector(3368.4,4160.6,-10705.2),Vector(3439.6,4263.2,-10934.2),Vector(3509.4,4367.5,-11161.9),Vector(3577.8,4473.9,-11388.2),Vector(3644.5,4581.9,-11612.7),Vector(3709.7,4692.0,-11835.4),Vector(3773.4,4803.8,-12056.8),Vector(3835.2,4917.7,-12275.5),Vector(3895.1,5033.5,-12492.8),Vector(3953.1,5151.5,-12707.5),Vector(4009.1,5271.6,-12919.4),Vector(4062.9,5393.7,-13129.1),Vector(4114.5,5517.9,-13335.6),Vector(4163.7,5644.1,-13540.0),Vector(4210.8,5772.6,-13740.7),Vector(4255.2,5903.6,-13938.7),Vector(4297.0,6036.5,-14133.1),Vector(4336.3,6171.8,-14324.0),Vector(4372.7,6309.3,-14511.6),Vector(4406.4,6449.2,-14695.3),Vector(4370.2,6571.9,-14713.7),Vector(4321.9,6704.5,-14713.7),Vector(4269.1,6849.1,-14713.7),Vector(4212.1,7005.5,-14713.7),Vector(4151.0,7173.6,-14713.7),Vector(4086.1,7351.9,-14713.7),Vector(4017.4,7540.6,-14713.7),Vector(3945.1,7739.1,-14713.7),Vector(3869.8,7946.7,-14713.7),Vector(3790.9,8163.0,-14713.7),Vector(3709.2,8387.4,-14713.7),Vector(3624.7,8619.6,-14713.7),Vector(3537.6,8858.8,-14713.7),Vector(3448.2,9104.9,-14713.7),Vector(3356.4,9356.6,-14713.7),Vector(3262.6,9614.5,-14713.7),Vector(3166.9,9877.4,-14713.7),Vector(3069.6,10144.5,-14713.7),Vector(2970.9,10416.3,-14713.7)]
  float crashStart = Time()
  while(IsValid(decoy))
  {
   float t = Time() - crashStart
   if(t >= 33.37)
    break
   float frame = t * 3.0
   int i = int(frame)
   if(i >= path.len() - 1)
    i = path.len() - 2
   float frac = frame - i
   if(frac > 1.0)
    frac = 1.0
   decoy.SetOrigin(endOrg + path[i] + (path[i + 1] - path[i]) * frac)
   if(IsValid(twin))
    twin.SetOrigin(worldEnd + wpath[i] + (wpath[i + 1] - wpath[i]) * frac)
   WaitFrame()
  }
 }
 if(IsValid(decoy))
  decoy.Destroy()
 if(IsValid(twin))
  twin.Destroy()
 printt("TF1_DECOY_DONE")
}

void function ServerCallback_TF1Story_Decoy()
{
 thread TF1Port_mp_tf1_outpost_207_DecoyRun()
 thread TF1Port_mp_tf1_outpost_207_DecoySky()
 printt("TF1_DECOY_CLIENT_START",Time())
}

void function TF1Port_mp_tf1_outpost_207_StoryClient_Init()
{
 if(GetMapName() != "mp_tf1_outpost_207")
  return
 TF1Port_mp_tf1_outpost_207_IntroAudioInit()
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_rail_charge_SB_1")
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_rail_fire_flash_SB")
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_rail_fire_beam_scale_SB")
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_exp_SB_carrier_NRG_LG_loop")
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_exp_SB_carrier_LG_loop")
 PrecacheParticleSystem($"mp_tf1_outpost_207_P_exp_SB_carrier_MD_loop")
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_outpost_207_StoryClient_Spawn)
}

void function TF1Port_mp_tf1_outpost_207_StoryClient_Spawn()
{
 TF1Port_mp_tf1_outpost_207_ship = TF1Port_mp_tf1_outpost_207_SkyProp($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage1.mdl",Vector(11906.5300,11874.9300,-11761.9600),Vector(0.0000,150.0000,90.0000))
 {
  entity base = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_base_dyn_tf1outpos.mdl",Vector(11933.0000,11890.0000,-11775.2000),Vector(0,45.0,0))
  int attach = base.LookupAttachment("barrel_attachment")
  entity barrel = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_barrel_tf1outpos.mdl",base.GetAttachmentOrigin(attach),Vector(15.0,45.0,0))
  TF1Port_mp_tf1_outpost_207_skyBases.append(base)
  TF1Port_mp_tf1_outpost_207_skyBarrels.append(barrel)
  TF1Port_mp_tf1_outpost_207_skyAngs.append(Vector(15.0,45.0,0))
  TF1Port_mp_tf1_outpost_207_skyRest.append(Vector(15.0,45.0,0))
 }
 {
  entity base = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_base_dyn_tf1outpos.mdl",Vector(11884.0000,11896.4000,-11778.5000),Vector(0,90.0,0))
  int attach = base.LookupAttachment("barrel_attachment")
  entity barrel = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_barrel_tf1outpos.mdl",base.GetAttachmentOrigin(attach),Vector(15.0,90.0,0))
  TF1Port_mp_tf1_outpost_207_skyBases.append(base)
  TF1Port_mp_tf1_outpost_207_skyBarrels.append(barrel)
  TF1Port_mp_tf1_outpost_207_skyAngs.append(Vector(15.0,90.0,0))
  TF1Port_mp_tf1_outpost_207_skyRest.append(Vector(15.0,90.0,0))
 }
 {
  entity base = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_base_dyn_tf1outpos.mdl",Vector(11867.0000,11815.0000,-11774.0000),Vector(0,180.0,0))
  int attach = base.LookupAttachment("barrel_attachment")
  entity barrel = TF1Port_mp_tf1_outpost_207_SkyProp($"models/weapons/railgun_outpost_207/railgun_skybox_barrel_tf1outpos.mdl",base.GetAttachmentOrigin(attach),Vector(30.0,180.0,0))
  TF1Port_mp_tf1_outpost_207_skyBases.append(base)
  TF1Port_mp_tf1_outpost_207_skyBarrels.append(barrel)
  TF1Port_mp_tf1_outpost_207_skyAngs.append(Vector(30.0,180.0,0))
  TF1Port_mp_tf1_outpost_207_skyRest.append(Vector(30.0,180.0,0))
 }
 printt("TF1_STORY_CLIENT_READY",TF1Port_mp_tf1_outpost_207_ship.GetOrigin())
thread TF1Port_mp_tf1_outpost_207_ShipWatch()
}

float function TF1Port_mp_tf1_outpost_207_AngleDelta(float from,float to)
{
 float d = to - from
 while(d > 180.0)
  d -= 360.0
 while(d < -180.0)
  d += 360.0
 return d
}

void function TF1Port_mp_tf1_outpost_207_ShipDrift(vector toOrg,vector toAng,float seconds)
{
 TF1Port_mp_tf1_outpost_207_driftToken++
 int mine = TF1Port_mp_tf1_outpost_207_driftToken
 vector fromOrg = TF1Port_mp_tf1_outpost_207_ship.GetOrigin()
 vector fromAng = TF1Port_mp_tf1_outpost_207_ship.GetAngles()
 vector dAng = Vector(TF1Port_mp_tf1_outpost_207_AngleDelta(fromAng.x,toAng.x),TF1Port_mp_tf1_outpost_207_AngleDelta(fromAng.y,toAng.y),TF1Port_mp_tf1_outpost_207_AngleDelta(fromAng.z,toAng.z))
 float start = Time()
 while(IsValid(TF1Port_mp_tf1_outpost_207_ship) && mine == TF1Port_mp_tf1_outpost_207_driftToken)
 {
  float f = (Time() - start) / seconds
  if(f > 1.0)
   f = 1.0
  TF1Port_mp_tf1_outpost_207_ship.SetOrigin(fromOrg + (toOrg - fromOrg) * f)
  TF1Port_mp_tf1_outpost_207_ship.SetAngles(fromAng + dAng * f)
  if(f >= 1.0)
   break
  WaitFrame()
 }
}

array<int> TF1Port_mp_tf1_outpost_207_dmgFx

void function TF1Port_mp_tf1_outpost_207_DmgFx(string alias,string kind)
{
 int attach = TF1Port_mp_tf1_outpost_207_ship.LookupAttachment(alias)
 int fx = 0
 if(kind == "NRG_LG_loop")
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_exp_SB_carrier_NRG_LG_loop")
 else if(kind == "LG_loop")
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_exp_SB_carrier_LG_loop")
 else
  fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_exp_SB_carrier_MD_loop")
 printt("TF1_CARRIER_FX",alias,kind,attach,fx)
 if(attach <= 0 || fx == 0)
  return
 TF1Port_mp_tf1_outpost_207_dmgFx.append(StartParticleEffectOnEntity(TF1Port_mp_tf1_outpost_207_ship,fx,FX_PATTACH_POINT_FOLLOW,attach))
}

// TF1 PlayCarrierDamageFX: the effects of every earlier hit stay and the new hit adds its own
void function TF1Port_mp_tf1_outpost_207_CarrierDamage(int stage)
{
 foreach(int handle in TF1Port_mp_tf1_outpost_207_dmgFx)
  EffectStop(handle,false,true)
 TF1Port_mp_tf1_outpost_207_dmgFx.clear()
 wait 0.1
 if(!IsValid(TF1Port_mp_tf1_outpost_207_ship))
  return
 if(stage >= 1)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_1","NRG_LG_loop")
 if(stage >= 1)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_1b","NRG_LG_loop")
 if(stage >= 2)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_2","LG_loop")
 if(stage >= 2)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_2b","MD_loop")
 if(stage >= 3)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_3","LG_loop")
 if(stage >= 3)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_3b","MD_loop")
 if(stage >= 4)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_4","LG_loop")
 if(stage >= 4)
  TF1Port_mp_tf1_outpost_207_DmgFx("Impact_4b","MD_loop")
}

void function TF1Port_mp_tf1_outpost_207_ShipWatch()
{
 // debug: reports sudden jumps of the carrier (entity origin and a hull attachment, which follows the root bone animation)
 vector lastOrg = Vector(0,0,0)
 vector lastAtt = Vector(0,0,0)
 bool first = true
 while(true)
 {
  if(TF1Port_mp_tf1_outpost_207_endOutcome != 0)return
  WaitFrame()
  if(!IsValid(TF1Port_mp_tf1_outpost_207_ship))
   continue
  int att = TF1Port_mp_tf1_outpost_207_ship.LookupAttachment("Impact_1")
  vector org = TF1Port_mp_tf1_outpost_207_ship.GetOrigin()
  vector attOrg = org
  if(att > 0)
   attOrg = TF1Port_mp_tf1_outpost_207_ship.GetAttachmentOrigin(att)
  if(!first)
  {
   float dOrg = Distance(org,lastOrg)
   float dAtt = Distance(attOrg,lastAtt)
   if(dOrg > 0.2 || dAtt > 0.05)
    printt("TF1_SHIP_JUMP",Time(),"org",dOrg,"att",dAtt)
  }
  lastOrg = org
  lastAtt = attOrg
  first = false
 }
}

void function TF1Port_mp_tf1_outpost_207_ReactIdle(float length,int token)
{
 wait length
 if(IsValid(TF1Port_mp_tf1_outpost_207_ship) && token == TF1Port_mp_tf1_outpost_207_reactToken)
  TF1Port_mp_tf1_outpost_207_ship.Anim_Play("ca_Outpost_idle")
}

void function TF1Port_mp_tf1_outpost_207_ApplyStage(int stage,int instant)
{
 for(int i = 0; i < 100 && !IsValid(TF1Port_mp_tf1_outpost_207_ship); i++)
  wait 0.1
 if(!IsValid(TF1Port_mp_tf1_outpost_207_ship))
  return
 asset model = $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage1.mdl"
 vector org = Vector(11906.5300,11874.9300,-11761.9600)
 vector ang = Vector(0.0000,150.0000,90.0000)
 float seconds = 60.0
 if(stage == 1)
 {
  model = $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage2.mdl"
  org = Vector(11907.0000,11881.0000,-11763.0000)
  ang = Vector(7.4897,168.3948,93.0258)
  seconds = 60.0
 }
 if(stage == 2)
 {
  model = $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage3.mdl"
  org = Vector(11905.5000,11885.0000,-11766.0000)
  ang = Vector(9.9884,-163.5153,92.7924)
  seconds = 120.0
 }
 if(stage == 3)
 {
  model = $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage4.mdl"
  org = Vector(11904.5000,11889.0000,-11768.0000)
  ang = Vector(17.0000,-139.0000,90.0000)
  seconds = 120.0
 }
 if(stage == 4)
 {
  model = $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage5.mdl"
  org = Vector(11902.5000,11894.0000,-11770.5000)
  ang = Vector(21.9119,-107.0167,84.6096)
  seconds = 120.0
 }
 string react = "ca_Outpost_idle"
 float length = 0.0
 if(stage >= 1 && instant == 0)
 {
  if(stage == 1)
  {
   react = "ca_Outpost_warpInterrupt"
   length = 15.93
  }
  else if(stage == 2)
  {
   react = "ca_Outpost_hit25"
   length = 12.23
  }
  else if(stage == 3)
  {
   react = "ca_Outpost_hit50"
   length = 12.23
  }
  else
  {
   react = "ca_Outpost_hit75"
   length = 12.23
  }
 }
 // swap to the new stage model behind the old one: a model swap shows the bind pose for a few frames before the animation takes effect
 entity previous = TF1Port_mp_tf1_outpost_207_ship
 entity fresh = TF1Port_mp_tf1_outpost_207_SkyProp(model,previous.GetOrigin(),previous.GetAngles())
 fresh.Hide()
 if(stage >= 1)
  fresh.Anim_Play(react)
 wait 0.3
 if(!IsValid(fresh))
  return
 TF1Port_mp_tf1_outpost_207_reactToken++
 int token = TF1Port_mp_tf1_outpost_207_reactToken
 // the old ship kept drifting during the wait; take over its exact placement
 if(IsValid(previous))
 {
  fresh.SetOrigin(previous.GetOrigin())
  fresh.SetAngles(previous.GetAngles())
 }
 fresh.Show()
 // restart at frame 0 now that the model is shown, so the reaction starts exactly where the old pose ended
 if(stage >= 1)
  fresh.Anim_Play(react)
 TF1Port_mp_tf1_outpost_207_ship = fresh
 if(IsValid(previous))
  previous.Destroy()
 if(length > 0.0)
  thread TF1Port_mp_tf1_outpost_207_ReactIdle(length,token)
 if(instant != 0)
 {
  TF1Port_mp_tf1_outpost_207_driftToken++
  TF1Port_mp_tf1_outpost_207_ship.SetOrigin(org)
  TF1Port_mp_tf1_outpost_207_ship.SetAngles(ang)
 }
 else
  thread TF1Port_mp_tf1_outpost_207_ShipDrift(org,ang,seconds)
 printt("TF1_STORY_CLIENT_STAGE",stage,instant)
 thread TF1Port_mp_tf1_outpost_207_CarrierDamage(stage)
}

void function ServerCallback_TF1Story_Stage(int stage,int instant)
{
 if(TF1Port_mp_tf1_outpost_207_endOutcome != 0)return
 thread TF1Port_mp_tf1_outpost_207_ApplyStage(stage,instant)
}

void function TF1Port_mp_tf1_outpost_207_EnginesHold(float seconds)
{
 wait seconds
 if(IsValid(TF1Port_mp_tf1_outpost_207_ship))
  TF1Port_mp_tf1_outpost_207_ship.Anim_Play("engines_forward")
}

// TF1 CapitalShip_MoveAwayFromStation: before the first hit the carrier creeps along its heading, accelerating for the first 30%
void function TF1Port_mp_tf1_outpost_207_Prepare(float seconds)
{
 for(int i = 0; i < 100 && !IsValid(TF1Port_mp_tf1_outpost_207_ship); i++)
  wait 0.1
 if(!IsValid(TF1Port_mp_tf1_outpost_207_ship))
  return
 TF1Port_mp_tf1_outpost_207_driftToken++
 int mine = TF1Port_mp_tf1_outpost_207_driftToken
 TF1Port_mp_tf1_outpost_207_ship.Anim_Play("ca_Outpost_warpPrepare")
 thread TF1Port_mp_tf1_outpost_207_EnginesHold(4.63)
 vector fromOrg = TF1Port_mp_tf1_outpost_207_ship.GetOrigin()
 vector toOrg = fromOrg + Vector(3.00000,5.19615,0)
 float start = Time()
 float accel = 0.3
 while(IsValid(TF1Port_mp_tf1_outpost_207_ship) && mine == TF1Port_mp_tf1_outpost_207_driftToken)
 {
  float f = (Time() - start) / seconds
  if(f > 1.0)
   f = 1.0
  float g = 0.0
  if(f < accel)
   g = (f * f / (2.0 * accel)) / (1.0 - accel / 2.0)
  else
   g = (f - accel / 2.0) / (1.0 - accel / 2.0)
  TF1Port_mp_tf1_outpost_207_ship.SetOrigin(fromOrg + (toOrg - fromOrg) * g)
  if(f >= 1.0)
   break
  WaitFrame()
 }
 printt("TF1_STORY_FIRST_MOVE_DONE")
}

void function ServerCallback_TF1Story_Prepare(float seconds)
{
 thread TF1Port_mp_tf1_outpost_207_Prepare(seconds)
}

int TF1Port_mp_tf1_outpost_207_radioToken
int TF1Port_mp_tf1_outpost_207_endOutcome
string TF1Port_mp_tf1_outpost_207_radioAlias
entity TF1Port_mp_tf1_outpost_207_brokenShip

void function ServerCallback_TF1OutpostWarpArrival()
{
 if(GetMapName() != "mp_tf1_outpost_207" || IsWatchingReplay())return
 entity player = GetLocalClientPlayer()
 if(!IsValid(player))return
 thread TF1Port_mp_tf1_outpost_207_WarpArrivalTail(player)
}

void function TF1Port_mp_tf1_outpost_207_WarpArrivalTail(entity player)
{
 player.EndSignal("OnDeath")
 player.EndSignal("OnDestroy")
 int index = GetParticleSystemIndex($"P_warpjump_FP")
 if(index == 0)
 {
  printt("TF1_OUTPOST_MISSING_WARP_SCREEN","P_warpjump_FP")
  return
 }
 int effect = StartParticleEffectInWorldWithHandle(index,<0,0,0>,<0,0,0>)
 float cleanupTime = Time() + 3.2
 OnThreadEnd(
  function() : (effect)
  {
   EffectStop(effect,true,false)
  }
 )
 // Immediate seeking can see a pending native collection and do nothing.
 // Warm up after initialization so the measured late peak moves under white.
 WaitFrame()
 EffectSetWarmUpTime(effect,1.3,false)
 printt("TF1_OUTPOST_WARP_WHITE_TRANSITION",Time())
 printt("TF1_OUTPOST_WARP_ENDING_WARMUP",1.3,Time())
 wait max(0.0,cleanupTime - Time())
}

void function ServerCallback_TF1OutpostConversation(int id)
{
 if(GetMapName() != "mp_tf1_outpost_207")return
 entity player = GetLocalClientPlayer()
 if(IsValid(player) && TF1Port_mp_tf1_outpost_207_radioAlias != "")StopSoundOnEntity(player,TF1Port_mp_tf1_outpost_207_radioAlias)
 TF1Port_mp_tf1_outpost_207_radioToken++
 TF1OutpostVoice_StoryStarted(TF1Port_mp_tf1_outpost_207_radioToken,player)
 thread TF1OutpostVoice_TrackedStory(id,TF1Port_mp_tf1_outpost_207_radioToken)
}

void function TF1Port_mp_tf1_outpost_207_RadioLine(string alias,string speaker,float duration,int team)
{
 entity player = GetLocalClientPlayer()
 if(!IsValid(player))return
 // Confirmed native right-side caller-ID API. Original TF1 VDU portraits are not supplied.
 CreateWaveform(speaker,team,duration)
 EmitSoundOnEntity(player,alias)
 TF1Port_mp_tf1_outpost_207_radioAlias = alias
 printt("TF1_OUTPOST_RADIO",speaker,alias,Time())
}

void function TF1Port_mp_tf1_outpost_207_RadioGroup(int id,int token)
{
 if(id == 0)
 {
  float started = Time()
  wait 0.750000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_08_01_mcor_og","Bish",1.777396,TEAM_MILITIA)
  wait 1.777396
  wait 0.800000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_08_02_mcor_og","MacAllan",2.256355,TEAM_MILITIA)
  wait 2.256355
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_08_03_mcor_og","Bish",4.379459,TEAM_MILITIA)
  wait 4.379459
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_08_04_mcor_og","Sarah",2.455125,TEAM_MILITIA)
  wait 2.455125
  return
 }
 if(id == 1)
 {
  float started = Time()
  wait 4.200000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_09_01_mcor_og","MacAllan",2.893375,TEAM_MILITIA)
  wait 2.893375
  return
 }
 if(id == 2)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_10_01_mcor_og","IMC radio",3.655125,TEAM_IMC)
  wait 3.655125
  wait 1.000000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_11_01_mcor_og","Blisk",4.798980,TEAM_IMC)
  wait 4.798980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_12_01_mcor_og","Graves",4.140146,TEAM_IMC)
  wait 4.140146
  wait 0.500000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_37_mcor_og","Spyglass",2.067292,TEAM_IMC)
  wait 2.067292
  wait 4.500000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_35_mcor_og","Graves",1.614667,TEAM_IMC)
  wait 1.614667
  return
 }
 if(id == 3)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_38_mcor_og","Blisk",1.468146,TEAM_IMC)
  wait 1.468146
  return
 }
 if(id == 4)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_39_mcor_og","Sarah",1.589375,TEAM_MILITIA)
  wait 1.589375
  return
 }
 if(id == 5)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_54_mcor_og","Bish",4.004000,TEAM_MILITIA)
  wait 4.004000
  wait 0.250000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_59_mcor_og","MacAllan",8.084000,TEAM_MILITIA)
  wait 8.084000
  return
 }
 if(id == 6)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_39a_mcor_og","Blisk",2.937334,TEAM_IMC)
  wait 2.937334
  wait 0.250000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_40_mcor_og","Graves",1.764730,TEAM_IMC)
  wait 1.764730
  wait 0.250000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_42_mcor_og","IMC radio",2.434938,TEAM_IMC)
  wait 2.434938
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_42a_mcor_og","IMC radio",3.112313,TEAM_IMC)
  wait 3.112313
  return
 }
 if(id == 7)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_43_mcor_og","Blisk",3.528000,TEAM_IMC)
  wait 3.528000
  wait 0.250000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_44_mcor_og","Graves",4.720000,TEAM_IMC)
  wait 4.720000
  return
 }
 if(id == 8)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog2_TS701_04_01_imc_boyle","Sarah",2.656980,TEAM_MILITIA)
  wait 2.656980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog2_TS701_05_01_imc_boyle","MacAllan",2.497500,TEAM_MILITIA)
  wait 2.497500
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog3_TS701_07_01_imc_boyle","Bish",2.701709,TEAM_MILITIA)
  wait 2.701709
  return
 }
 if(id == 9)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog3_TS701_08_01_imc_boyle","Sarah",2.310063,TEAM_MILITIA)
  wait 2.310063
  return
 }
 if(id == 10)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog3_TS701_09_01_imc_boyle","MacAllan",3.757730,TEAM_MILITIA)
  wait 3.757730
  return
 }
 if(id == 11)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog4_TS701_10_01_imc_boyle","Bish",1.758667,TEAM_MILITIA)
  wait 1.758667
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_17_01_imc_boyle","Sarah",5.324396,TEAM_MILITIA)
  wait 5.324396
  return
 }
 if(id == 12)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog4_TS701_11_01_imc_boyle","Blisk",3.567771,TEAM_IMC)
  wait 3.567771
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog4_TS701_12_01_imc_boyle","Graves",4.393125,TEAM_IMC)
  wait 4.393125
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog4_TS701_13_01_imc_boyle","Blisk",1.007959,TEAM_IMC)
  wait 1.007959
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_14_01_imc_boyle","Graves",2.326355,TEAM_IMC)
  wait 2.326355
  return
 }
 if(id == 13)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_15_01_imc_boyle","Blisk",2.133667,TEAM_IMC)
  wait 2.133667
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_16_01_imc_boyle","Graves",4.590667,TEAM_IMC)
  wait 4.590667
  return
 }
 if(id == 14)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_32_01_mcor_bt","MacAllan",2.322834,TEAM_MILITIA)
  wait 2.322834
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_33_01_mcor_bt","Sarah",4.705292,TEAM_MILITIA)
  wait 4.705292
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_34_01_mcor_grunt1","Bish",1.054605,TEAM_MILITIA)
  wait 1.054605
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_35_01_mcor_grunt2","MacAllan",1.992980,TEAM_MILITIA)
  wait 1.992980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_42_01_mcor_grunt5","Bish",1.330292,TEAM_MILITIA)
  wait 1.330292
  return
 }
 if(id == 15)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_37_01_mcor_grunt4","Sarah",3.276271,TEAM_MILITIA)
  wait 3.276271
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_39_01_mcor_grunt4","Bish",2.990667,TEAM_MILITIA)
  wait 2.990667
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_41_01_mcor_grunt5","MacAllan",1.468021,TEAM_MILITIA)
  wait 1.468021
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_42_01_mcor_grunt5","Bish",1.330292,TEAM_MILITIA)
  wait 1.330292
  return
 }
 if(id == 16)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_43_01_mcor_grunt5","Sarah",1.156355,TEAM_MILITIA)
  wait 1.156355
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_45_01_mcor_grunt7","MacAllan",2.154521,TEAM_MILITIA)
  wait 2.154521
  return
 }
 if(id == 17)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_43_01_mcor_grunt5","Sarah",1.156355,TEAM_MILITIA)
  wait 1.156355
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_44_01_mcor_grunt6","MacAllan",3.716750,TEAM_MILITIA)
  wait 3.716750
  return
 }
 if(id == 18)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE102_01a_01_imc_ai","MacAllan",2.798125,TEAM_MILITIA)
  wait 2.798125
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_01_01_mcor_grunt1","Sarah",2.459146,TEAM_MILITIA)
  wait 2.459146
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_02_01_mcor_grunt2","Bish",5.912084,TEAM_MILITIA)
  wait 5.912084
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_03_01_mcor_grunt3","MacAllan",5.877167,TEAM_MILITIA)
  wait 5.877167
  return
 }
 if(id == 19)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_18_01_mcor_bt","Blisk",3.595646,TEAM_IMC)
  wait 3.595646
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_21_01_mcor_bt","Graves",3.224334,TEAM_IMC)
  wait 3.224334
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_22_01_imc_facilityPA","Spyglass",4.265480,TEAM_IMC)
  wait 4.265480
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_23_01_imc_facilityPA","Graves",2.582334,TEAM_IMC)
  wait 2.582334
  return
 }
 if(id == 20)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_25_01_mcor_bt","Graves",3.237292,TEAM_IMC)
  wait 3.237292
  return
 }
 if(id == 21)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_36_mcor_og","Graves",3.462084,TEAM_IMC)
  wait 3.462084
  return
 }
 if(id == 22)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_18_01_imc_boyle","Graves",1.196000,TEAM_IMC)
  wait 1.196000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_19_01_imc_boyle","Blisk",3.377459,TEAM_IMC)
  wait 3.377459
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog5_TS701_20_01_imc_boyle","Spyglass",2.438980,TEAM_IMC)
  wait 2.438980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE100_01_01_imc_ai","Graves",5.232063,TEAM_IMC)
  wait 5.232063
  return
 }
 if(id == 23)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_53_01_mcor_grunt10","MacAllan",2.170417,TEAM_MILITIA)
  wait 2.170417
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_54_01_mcor_grunt11","Sarah",2.724250,TEAM_MILITIA)
  wait 2.724250
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_55_01_mcor_grunt12","Bish",3.712084,TEAM_MILITIA)
  wait 3.712084
  return
 }
 if(id == 24)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM121_02_01_mcor_bt","MacAllan",1.718792,TEAM_MILITIA)
  wait 1.718792
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM121_03_01_mcor_bt","Bish",5.693938,TEAM_MILITIA)
  wait 5.693938
  return
 }
 if(id == 25)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM121_01_01_imc_facilityPA","MacAllan",3.787355,TEAM_MILITIA)
  wait 3.787355
  return
 }
 if(id == 26)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_06_01_imc_facilityPA","Sarah",3.473959,TEAM_MILITIA)
  wait 3.473959
  return
 }
 if(id == 27)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_06_01_mcor_grunt6","MacAllan",4.057980,TEAM_MILITIA)
  wait 4.057980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_07_01_mcor_grunt3","Bish",2.720250,TEAM_MILITIA)
  wait 2.720250
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_09_01_mcor_grunt7","Sarah",3.084459,TEAM_MILITIA)
  wait 3.084459
  return
 }
 if(id == 28)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_46_01_mcor_grunt8","Graves",1.465063,TEAM_IMC)
  wait 1.465063
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_47_01_mcor_grunt9","Blisk",4.118355,TEAM_IMC)
  wait 4.118355
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_48_01_mcor_grunt10","Graves",1.492563,TEAM_IMC)
  wait 1.492563
  return
 }
 if(id == 29)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_47_01_mcor_grunt9","Blisk",4.118355,TEAM_IMC)
  wait 4.118355
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_48_01_mcor_grunt10","Graves",1.492563,TEAM_IMC)
  wait 1.492563
  return
 }
 if(id == 30)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_49_01_mcor_grunt6","Blisk",2.601459,TEAM_IMC)
  wait 2.601459
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_50_01_mcor_grunt7","Spyglass",2.093667,TEAM_IMC)
  wait 2.093667
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_52_01_mcor_grunt9","Graves",5.078459,TEAM_IMC)
  wait 5.078459
  return
 }
 if(id == 31)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_49_01_mcor_grunt6","Blisk",2.601459,TEAM_IMC)
  wait 2.601459
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_50_01_mcor_grunt7","Spyglass",2.093667,TEAM_IMC)
  wait 2.093667
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_51_01_mcor_grunt8","Graves",3.223667,TEAM_IMC)
  wait 3.223667
  return
 }
 if(id == 32)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_04_01_mcor_grunt4","Blisk",2.598146,TEAM_IMC)
  wait 2.598146
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_05_01_mcor_grunt5","Graves",3.252917,TEAM_IMC)
  wait 3.252917
  return
 }
 if(id == 33)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_07_01_mcor_grunt","MacAllan",3.762917,TEAM_MILITIA)
  wait 3.762917
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_08_01_mcor_grunt","Bish",2.912021,TEAM_MILITIA)
  wait 2.912021
  return
 }
 if(id == 34)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_11_01_mcor_grunt","Sarah",2.460730,TEAM_MILITIA)
  wait 2.460730
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_12_01_mcor_grunt","Bish",2.969125,TEAM_MILITIA)
  wait 2.969125
  return
 }
 if(id == 35)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_09_01_mcor_grunt","MacAllan",4.059938,TEAM_MILITIA)
  wait 4.059938
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_10_01_mcor_grunt","Sarah",1.699209,TEAM_MILITIA)
  wait 1.699209
  return
 }
 if(id == 36)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_13_01_mcor_grunt","MacAllan",3.531355,TEAM_MILITIA)
  wait 3.531355
  return
 }
 if(id == 37)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_14_01_mcor_player","MacAllan",3.508209,TEAM_MILITIA)
  wait 3.508209
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_15_01_mcor_bt","Bish",1.216230,TEAM_MILITIA)
  wait 1.216230
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_16_01_mcor_bt","Sarah",2.450000,TEAM_MILITIA)
  wait 2.450000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_17_01_mcor_bt","MacAllan",3.914646,TEAM_MILITIA)
  wait 3.914646
  return
 }
 if(id == 38)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_07_01_imc_facilityPA","Blisk",5.474250,TEAM_IMC)
  wait 5.474250
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_08_01_imc_facilityPA","Graves",3.562230,TEAM_IMC)
  wait 3.562230
  return
 }
 if(id == 39)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_09_01_imc_facilityPA","Graves",1.895021,TEAM_IMC)
  wait 1.895021
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_10_01_imc_facilityPA","Blisk",2.706334,TEAM_IMC)
  wait 2.706334
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_aboveDome_BM122_11_01_imc_facilityPA","Spyglass",5.577021,TEAM_IMC)
  wait 5.577021
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_02_01_mcor_sarah","Graves",2.073438,TEAM_IMC)
  wait 2.073438
  return
 }
 if(id == 40)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_04_01_mcor_barker","Blisk",3.157855,TEAM_IMC)
  wait 3.157855
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_06_01_mcor_gates","Graves",4.615084,TEAM_IMC)
  wait 4.615084
  return
 }
 if(id == 41)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_10_01_mcor_grunt8","Graves",2.008438,TEAM_IMC)
  wait 2.008438
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_11_01_mcor_grunt9","Blisk",2.494980,TEAM_IMC)
  wait 2.494980
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_12_01_mcor_grunt12","Spyglass",3.206209,TEAM_IMC)
  wait 3.206209
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_Spoke0_BE331_13_01_mcor_bt","Graves",4.930021,TEAM_IMC)
  wait 4.930021
  return
 }
 if(id == 42)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_63_mcor_og","MacAllan",4.860063,TEAM_MILITIA)
  wait 4.860063
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_19_mcor_og","Bish",1.850730,TEAM_MILITIA)
  wait 1.850730
  return
 }
 if(id == 43)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_20_mcor_og","MacAllan",2.413125,TEAM_MILITIA)
  wait 2.413125
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_21_mcor_og","Sarah",4.026813,TEAM_MILITIA)
  wait 4.026813
  return
 }
 if(id == 44)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_14_01_mcor_player","MacAllan",5.631063,TEAM_MILITIA)
  wait 5.631063
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_adds_STS801_15_01_mcor_bt","Sarah",1.516000,TEAM_MILITIA)
  wait 1.516000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_01_01_mcor_og","Bish",2.414063,TEAM_MILITIA)
  wait 2.414063
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_02_01_mcor_og","MacAllan",1.748792,TEAM_MILITIA)
  wait 1.748792
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_01_02_mcor_og","Sarah",2.160500,TEAM_MILITIA)
  wait 2.160500
  return
 }
 if(id == 45)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_03_01_mcor_og","Spyglass",5.265605,TEAM_IMC)
  wait 5.265605
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_04_01_mcor_og","Graves",6.756209,TEAM_IMC)
  wait 6.756209
  return
 }
 if(id == 46)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_21a_mcor_og","Spyglass",3.603855,TEAM_IMC)
  wait 3.603855
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_22_mcor_og","Blisk",2.128063,TEAM_IMC)
  wait 2.128063
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_23_mcor_og","Graves",2.954417,TEAM_IMC)
  wait 2.954417
  return
 }
 if(id == 47)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BTTackle_STS386_01_01_mcor_bt","Blisk",2.175563,TEAM_IMC)
  wait 2.175563
  return
 }
 if(id == 48)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog1_TS701_01_01_imc_boyle","Blisk",3.141688,TEAM_IMC)
  wait 3.141688
  return
 }
 if(id == 49)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog1_TS701_02_01_imc_boyle","Blisk",2.345959,TEAM_IMC)
  wait 2.345959
  return
 }
 if(id == 50)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_BoyleLog1_TS701_03_01_imc_boyle","Blisk",1.712938,TEAM_IMC)
  wait 1.712938
  return
 }
 if(id == 51)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_23a_mcor_og","Spyglass",2.686813,TEAM_IMC)
  wait 2.686813
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_24_mcor_og","Graves",5.441709,TEAM_IMC)
  wait 5.441709
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_25_mcor_og","Spyglass",0.684250,TEAM_IMC)
  wait 0.684250
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_26_mcor_og","Graves",2.712396,TEAM_IMC)
  wait 2.712396
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_26a_mcor_og","Spyglass",2.674875,TEAM_IMC)
  wait 2.674875
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_27_mcor_og","Graves",4.652563,TEAM_IMC)
  wait 4.652563
  return
 }
 if(id == 52)
 {
  float started = Time()
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_28_mcor_og","MacAllan",2.277542,TEAM_MILITIA)
  wait 2.277542
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_29_mcor_og","Bish",1.412000,TEAM_MILITIA)
  wait 1.412000
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_29a_mcor_og","Barker",3.093105,TEAM_MILITIA)
  wait 3.093105
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_30_mcor_og","MacAllan",1.932021,TEAM_MILITIA)
  wait 1.932021
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_31_mcor_og","Barker",1.890146,TEAM_MILITIA)
  wait 1.890146
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_32_mcor_og","MacAllan",5.411125,TEAM_MILITIA)
  wait 5.411125
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_33_mcor_og","Barker",3.600042,TEAM_MILITIA)
  wait 3.600042
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR411_34_mcor_og","MacAllan",4.025125,TEAM_MILITIA)
  wait 4.025125
  return
 }
 if(id == 53)
 {
  float started = Time()
  wait max(0.0,started + 0.000000 - Time())
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_05_01_mcor_og","Blisk",5.156667,TEAM_IMC)
  wait max(5.156667,started + 5.500000 - Time())
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_06_01_mcor_og","Graves",4.553480,TEAM_IMC)
  wait max(4.553480,started + 10.300000 - Time())
  if(token != TF1Port_mp_tf1_outpost_207_radioToken)return
  waitthread TF1Port_mp_tf1_outpost_207_RadioLine("diag_sp_addtional_TR401_07_01_mcor_og","Blisk",2.264500,TEAM_IMC)
  wait 2.264500
  return
 }
 printt("TF1_OUTPOST_UNKNOWN_CONVERSATION",id)
}

void function ServerCallback_TF1OutpostOutcome(int outcome,int sync)
{
 if(GetMapName() != "mp_tf1_outpost_207" || !IsValid(TF1Port_mp_tf1_outpost_207_ship))return
 if(outcome != 2)
 {
  TF1Port_mp_tf1_outpost_207_radioToken++
  entity player = GetLocalClientPlayer()
  if(IsValid(player) && TF1Port_mp_tf1_outpost_207_radioAlias != "")StopSoundOnEntity(player,TF1Port_mp_tf1_outpost_207_radioAlias)
 }
 TF1Port_mp_tf1_outpost_207_endOutcome = outcome
 TF1Port_mp_tf1_outpost_207_driftToken++
 TF1Port_mp_tf1_outpost_207_reactToken++
 if(outcome == 1)return
 foreach(int handle in TF1Port_mp_tf1_outpost_207_dmgFx)
  EffectStop(handle,false,true)
 TF1Port_mp_tf1_outpost_207_dmgFx.clear()
 if(outcome == 2)
 {
  if(IsValid(TF1Port_mp_tf1_outpost_207_brokenShip))return
  TF1Port_mp_tf1_outpost_207_brokenShip = TF1Port_mp_tf1_outpost_207_SkyProp($"models/vehicle/imc_carrier/imc_carrier207_tf1campaign_broken.mdl",TF1Port_mp_tf1_outpost_207_ship.GetOrigin(),TF1Port_mp_tf1_outpost_207_ship.GetAngles())
  if(TF1Port_mp_tf1_outpost_207_brokenShip.LookupSequence("ca_Outpost_end_explode") < 0)
  {
   printt("TF1_OUTPOST_MISSING_END_ANIMATION","ca_Outpost_end_explode")
   TF1Port_mp_tf1_outpost_207_brokenShip.Destroy()
   return
  }
  TF1Port_mp_tf1_outpost_207_brokenShip.Anim_Play("ca_Outpost_end_explode")
  if(sync == 0)
  {
   int fx = GetParticleSystemIndex($"mp_tf1_outpost_207_P_exp_SB_carrier_XLG")
   int attach = TF1Port_mp_tf1_outpost_207_brokenShip.LookupAttachment("break_impact_LG_1")
   if(fx != 0 && attach > 0)StartParticleEffectOnEntity(TF1Port_mp_tf1_outpost_207_brokenShip,fx,FX_PATTACH_POINT_FOLLOW,attach)
   else printt("TF1_OUTPOST_MISSING_BREAKUP_EFFECT",fx,attach)
  }
  TF1Port_mp_tf1_outpost_207_ship.Hide()
  printt("TF1_OUTPOST_SENTINEL_DESTROYED")
  return
 }
 string anim = outcome == 3 ? "ca_Outpost_end_early_escape" : "ca_Outpost_end_limp_away"
 if(TF1Port_mp_tf1_outpost_207_ship.LookupSequence(anim) < 0)
 {
  printt("TF1_OUTPOST_MISSING_END_ANIMATION",anim)
  return
 }
 TF1Port_mp_tf1_outpost_207_ship.Anim_Play(anim)
 printt("TF1_OUTPOST_SENTINEL_ESCAPE",anim)
}

void function TF1Port_mp_tf1_outpost_207_IntroAudioInit() {}

void function TF1OutpostVoice_TrackedStory(int id,int token)
{
 OnThreadEnd(
  function() : (token)
  {
   TF1OutpostVoice_StoryFinished(token)
  }
 )
 waitthread TF1Port_mp_tf1_outpost_207_RadioGroup(id,token)
}
