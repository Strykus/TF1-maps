global function TF1Port_mp_tf1_outpost_207_ScriptedModels_Init
void function TF1Port_mp_tf1_outpost_207_ScriptedModels_Init()
{
 if(GetMapName()!="mp_tf1_outpost_207")return
 PrecacheParticleSystem($"veh_gunship_door_open_lip_01")
 PrecacheParticleSystem($"veh_gunship_door_open_01")
 PrecacheModel($"models/weapons/railgun_outpost_207/railgun_outpost_01_base_dynamic_tf1outpos.mdl")
 PrecacheModel($"models/weapons/railgun_outpost_207/railgun_outpost_01_barrel_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage1.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage2.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage3.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage4.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage5.mdl")
 PrecacheModel($"models/weapons/railgun_outpost_207/railgun_skybox_base_dyn_tf1outpos.mdl")
 PrecacheModel($"models/weapons/railgun_outpost_207/railgun_skybox_barrel_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/capital_ship_birmingham/birmingham_decoy_sky_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/capital_ship_birmingham/birmingham_decoy_ghost_tf1outpos.mdl")
 PrecacheModel($"models/industrial/safety_baton_tf1outpos.mdl")
 PrecacheModel($"models/robots/marvin/marvin_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/titans/atlas/atlas_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/robots/spectre/spectre_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/crow_dropship/crow_dropship_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/goblin_dropship/goblin_dropship_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/humans/mcor_hero/sarah/sarah_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/humans/imc_villain/spyglass/spyglass_tf1intro_tf1outpos.mdl")
 PrecacheModel($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1cockpit_tf1outpos.mdl")
 PrecacheModel($"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1cockpit_tf1outpos.mdl")
 PrecacheModel($"models/vehicle/imc_carrier/imc_carrier207_tf1campaign_broken.mdl")
 TF1Port_mp_tf1_outpost_207_TF1Intro_Register()
 AddCallback_EntitiesDidLoad(TF1Port_mp_tf1_outpost_207_ScriptedModels_Spawn)
}

entity prop_outpost_cannon_base
entity prop_outpost_cannon_barrel
entity rot_outpost_cannon_base
entity rot_outpost_cannon_barrel

// Animated prop riding on an invisible mover: the mover turns, the prop plays its sequences.
entity function CreateCannonProp(asset model,vector origin,vector angles,int solidType,entity mover)
{
 entity prop = CreatePropDynamic(model,origin,angles,solidType)
 prop.SetParent(mover,"",false,0.0)
 prop.SetLocalOrigin(<0,0,0>)
 prop.SetLocalAngles(<0,0,0>)
 return prop
}


void function TF1Port_mp_tf1_outpost_207_ScriptedModels_Spawn()
{
 {
  rot_outpost_cannon_base=CreateScriptMover(Vector(-60.438300,-735.946000,320.000000),Vector(0.0,90.0,0))
  prop_outpost_cannon_base=CreateCannonProp($"models/weapons/railgun_outpost_207/railgun_outpost_01_base_dynamic_tf1outpos.mdl",Vector(-60.438300,-735.946000,320.000000),Vector(0.0,90.0,0),6,rot_outpost_cannon_base)
  prop_outpost_cannon_base.SetScriptName("outpost_cannon_base")
  printt("TF1_SCRIPTED_MODEL_SPAWNED","outpost_cannon_base",prop_outpost_cannon_base.GetOrigin(),prop_outpost_cannon_base.GetAngles())
 }
 {
  int attach=prop_outpost_cannon_base.LookupAttachment("barrel_attachment")
  vector org=prop_outpost_cannon_base.GetAttachmentOrigin(attach)
  vector ang=prop_outpost_cannon_base.GetAttachmentAngles(attach)+Vector(10.0,0,0)
  rot_outpost_cannon_barrel=CreateScriptMover(org,ang)
  prop_outpost_cannon_barrel=CreateCannonProp($"models/weapons/railgun_outpost_207/railgun_outpost_01_barrel_tf1outpos.mdl",org,ang,6,rot_outpost_cannon_barrel)
  prop_outpost_cannon_barrel.SetScriptName("outpost_cannon_barrel")
  prop_outpost_cannon_barrel.Anim_Play("flaps_close_idle")
  printt("TF1_SCRIPTED_MODEL_SPAWNED","outpost_cannon_barrel",prop_outpost_cannon_barrel.GetOrigin(),prop_outpost_cannon_barrel.GetAngles())
 }
 thread TF1Port_mp_tf1_outpost_207_StoryInit()
}


vector TF1Port_mp_tf1_outpost_207_skycam = Vector(11904.0000,11904.0000,-11776.0000)
int TF1Port_mp_tf1_outpost_207_stage
vector TF1Port_mp_tf1_outpost_207_rest

void function TF1Port_mp_tf1_outpost_207_StoryInit()
{
 if(!TF1Port_mp_tf1_outpost_207_CampaignEnabled())return
 TF1Port_mp_tf1_outpost_207_CampaignInit()
 FlagInit("TF1Port_mp_tf1_outpost_207_DecoyCannonOpen")
 TF1Port_mp_tf1_outpost_207_rest = rot_outpost_cannon_barrel.GetAngles()
 AddCallback_OnClientConnected(TF1Port_mp_tf1_outpost_207_StoryOnConnect)
 // test helper: "tf1_restart" in the client console reloads the map (dropship intro and story start over)
 AddClientCommandCallback("tf1_restart",TF1Port_mp_tf1_outpost_207_RestartMatch)
 printt("TF1_STORY_SERVER_READY")
 thread TF1Port_mp_tf1_outpost_207_CampaignWatch()
 thread TF1Port_mp_tf1_outpost_207_StoryDecoy()
 thread TF1Port_mp_tf1_outpost_207_DecoyDestroyedLater()
 thread TF1Port_mp_tf1_outpost_207_IntroMarvins()
 thread TF1Port_mp_tf1_outpost_207_IntroTitan()
 thread TF1Port_mp_tf1_outpost_207_IntroMilitia()
 thread TF1Port_mp_tf1_outpost_207_IntroSpectres()
}

void function TF1Port_mp_tf1_outpost_207_IntroWait(float offset)
{
 FlagWait("TF1Port_mp_tf1_outpost_207_IntroFlightStarted")
 wait max(0.0,TF1Port_mp_tf1_outpost_207_introStart + offset - Time())
}

void function TF1Port_mp_tf1_outpost_207_IntroImcVO(entity speaker,string event)
{
 if(!IsValid(speaker))
  return
 int heard = 0
 foreach(entity player in GetPlayerArrayOfTeam(TEAM_IMC))
 {
  if(!IsValid(player) || Distance(player.GetOrigin(),speaker.GetOrigin()) > 2500.0)
   continue
  EmitSoundOnEntityOnlyToPlayer(speaker,player,event)
  heard++
 }
 printt("TF1_INTRO_IMC_VO",event,Time(),heard)
}

void function TF1Port_mp_tf1_outpost_207_IntroMilitiaVO(entity speaker,string event)
{
 if(!IsValid(speaker))
  return
 int heard = 0
 foreach(entity player in GetPlayerArrayOfTeam(TEAM_MILITIA))
 {
  if(!IsValid(player) || Distance(player.GetOrigin(),speaker.GetOrigin()) > 5000.0)
   continue
  EmitSoundOnEntityOnlyToPlayer(speaker,player,event)
  heard++
 }
 printt("TF1_INTRO_MCOR_VO",event,Time(),heard)
}

// TF1 draws titan_ar_marker (bodygroup "hitpoints") with alpha from VMTCallback_MPEntityARAlpha,
// which is 0 for any non-NPC without ent.s.showWeakpoints; these story titans are props, so use
// the model's empty hitpoints variant instead of drawing the unconvertible UnlitTwoTexture overlay.
void function TF1Port_mp_tf1_outpost_207_HideTitanWeakpoints(entity titan)
{
 int hitpoints = titan.FindBodyGroup("hitpoints")
 printt("TF1_INTRO_ATLAS_WEAKPOINTS",hitpoints,"target",1)
 if(hitpoints >= 0)
  titan.SetBodygroup(hitpoints,1)
}

// TF1 IntroTitan_IMC (props instead of NPCs): the titan idles with pilot and crew, then the activation animations play together
void function TF1Port_mp_tf1_outpost_207_IntroTitan()
{
 vector refOrg = Vector(2680.0,-1311.0,-413.0)
 vector refAng = Vector(0.0,97.0,0.0)
 vector titanOrg = refOrg + Vector(0,0,-35)
  entity titan = CreatePropDynamic($"models/titans/atlas/atlas_tf1intro_tf1outpos.mdl",titanOrg,refAng)
 TF1Port_mp_tf1_outpost_207_HideTitanWeakpoints(titan)
 entity pilot = CreatePropDynamic($"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1intro_tf1outpos.mdl",titanOrg,refAng)
 vector crewOrg = refOrg + Vector(0,0,-35)
 entity crew = CreatePropDynamic($"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1intro_tf1outpos.mdl",crewOrg,refAng)
 TF1IntroAI_SetNameTag(pilot,"tf1_intro_name_imc_pilot")
 TF1IntroAI_SetNameTag(crew,"tf1_intro_name_imc_heppe")
 titan.Anim_PlayWithRefPoint("at_titan_activation_idle",titanOrg,refAng,0.0)
 // the pilot animation is baked into the titan's model space (TF1 parents him to the HIJACK attachment): copy the titan's placement
 // (Anim_PlayWithRefPoint offsets the titan from the ref point; parenting a prop drops it to an attachment)
 WaitFrame()
 pilot.SetOrigin(titan.GetOrigin())
 pilot.SetAngles(titan.GetAngles())
 pilot.Anim_Play("pt_titan_activation_pilot_idle")
 // the titan's root motion is baked into the pilot animation, so he only takes the titan's placement at each start
 crew.Anim_PlayWithRefPoint("pt_titan_activation_crew_idle",crewOrg,refAng,0.0)
 printt("TF1_INTRO_TITAN",titan.LookupSequence("at_titan_activation"),titan.LookupAttachment("HIJACK"),pilot.LookupSequence("pt_titan_activation_pilot"),crew.LookupSequence("pt_titan_activation_crew"))
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(26.0)
 TF1IntroAI_SetNameTag(titan,"tf1_intro_name_imc_booting")
 titan.Anim_PlayWithRefPoint("at_titan_activation",titanOrg,refAng,0.0)
 pilot.SetOrigin(titan.GetOrigin())
 pilot.SetAngles(titan.GetAngles())
 pilot.Anim_Play("pt_titan_activation_pilot")
 crew.Anim_PlayWithRefPoint("pt_titan_activation_crew",crewOrg,refAng,0.0)
 printt("TF1_INTRO_TITAN_ACTIVATE",Time())
 float activationLength = titan.GetSequenceDuration("at_titan_activation")
 thread TF1Port_mp_tf1_outpost_207_IntroTitanVO(titan,crew)
 thread TF1Port_mp_tf1_outpost_207_IntroTitanReadyVO(titan,activationLength)
 thread TF1IntroAI_AfterAnimation(crew,TF1_INTRO_AI_GRUNT,TEAM_IMC,"imc_crew",19.0)
 thread TF1IntroAI_AfterAnimation(titan,TF1_INTRO_AI_TITAN,TEAM_IMC,"imc_titan",activationLength + 0.5)
 // The pilot disappears at the original hatch_closed event.
 wait 20.5
 pilot.Hide()
 pilot.SetScriptName("")
 TF1IntroAI_SetNameTag(titan,"tf1_intro_name_imc_messerly")
}

void function TF1Port_mp_tf1_outpost_207_IntroTitanVO(entity titan,entity crew)
{
 TF1Port_mp_tf1_outpost_207_IntroImcVO(titan,"diag_sp_addtional_TR411_44a_mcor_og")
 wait 1.25
 TF1Port_mp_tf1_outpost_207_IntroImcVO(crew,"diag_sp_addtional_TR411_45_mcor_og")
 wait 4.6
 TF1Port_mp_tf1_outpost_207_IntroImcVO(titan,"diag_sp_addtional_TR411_46_mcor_og")
 wait 3.0
 TF1Port_mp_tf1_outpost_207_IntroImcVO(crew,"diag_sp_addtional_TR411_55_mcor_og")
 wait 6.0
 TF1Port_mp_tf1_outpost_207_IntroImcVO(titan,"diag_sp_addtional_TR411_57_mcor_og")
 wait 3.0
 TF1Port_mp_tf1_outpost_207_IntroImcVO(crew,"diag_sp_addtional_TR411_60_mcor_og")
}

void function TF1Port_mp_tf1_outpost_207_IntroTitanReadyVO(entity titan,float activationLength)
{
 wait activationLength
 waitthread TF1IntroAI_ImcTitanReadyVoice(titan)
}

// Intro marvins: TF1 marvin model with the original traffic controller animations (looping)
void function TF1Port_mp_tf1_outpost_207_IntroMarvins()
{
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(0.0)
 {
  entity marvin = CreatePropDynamic($"models/robots/marvin/marvin_tf1intro_tf1outpos.mdl",Vector(4000.0000,-800.0000,-695.0000),Vector(0.0000,0.0000,0.0000))
  marvin.Anim_Play("mv_trafic_controller_A")
  int right = marvin.LookupAttachment("R_HAND")
  int left = marvin.LookupAttachment("L_HAND")
  printt("TF1_INTRO_MARVIN",marvin.LookupSequence("mv_trafic_controller_A"),right,left)
  entity batonR = CreatePropDynamic($"models/industrial/safety_baton_tf1outpos.mdl",marvin.GetAttachmentOrigin(right),marvin.GetAttachmentAngles(right) + Vector(0,0,180))
  batonR.SetParent(marvin,"R_HAND",true)
  entity batonL = CreatePropDynamic($"models/industrial/safety_baton_tf1outpos.mdl",marvin.GetAttachmentOrigin(left),marvin.GetAttachmentAngles(left))
  batonL.SetParent(marvin,"L_HAND")
  thread TF1IntroAI_RemoveMarvinAtMatch(marvin,batonR,batonL)
 }
 {
  entity marvin = CreatePropDynamic($"models/robots/marvin/marvin_tf1intro_tf1outpos.mdl",Vector(4000.0000,-650.0000,-695.0000),Vector(0.0000,0.0000,0.0000))
  marvin.Anim_Play("mv_trafic_controller_B")
  int right = marvin.LookupAttachment("R_HAND")
  int left = marvin.LookupAttachment("L_HAND")
  printt("TF1_INTRO_MARVIN",marvin.LookupSequence("mv_trafic_controller_B"),right,left)
  entity batonR = CreatePropDynamic($"models/industrial/safety_baton_tf1outpos.mdl",marvin.GetAttachmentOrigin(right),marvin.GetAttachmentAngles(right) + Vector(0,0,180))
  batonR.SetParent(marvin,"R_HAND",true)
  entity batonL = CreatePropDynamic($"models/industrial/safety_baton_tf1outpos.mdl",marvin.GetAttachmentOrigin(left),marvin.GetAttachmentAngles(left))
  batonL.SetParent(marvin,"L_HAND")
  thread TF1IntroAI_RemoveMarvinAtMatch(marvin,batonR,batonL)
 }
}

bool function TF1Port_mp_tf1_outpost_207_RestartMatch(entity player,array<string> args)
{
 printt("TF1_RESTART_REQUESTED",player)
 GameRules_ChangeMap(GetMapName(),GameRules_GetGameMode())
 return true
}

void function TF1Port_mp_tf1_outpost_207_StoryOnConnect(entity player)
{
 thread TF1Port_mp_tf1_outpost_207_StorySendLater(player)
}

void function TF1Port_mp_tf1_outpost_207_StorySendLater(entity player)
{
 wait 5.0
 if(IsValid(player))
 {
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1Story_Stage",TF1Port_mp_tf1_outpost_207_stage,1)
  if(TF1Port_mp_tf1_outpost_207_outcome != 0)
   Remote_CallFunction_NonReplay(player,"ServerCallback_TF1OutpostOutcome",TF1Port_mp_tf1_outpost_207_outcome,1)
 }
}

// Same mapping as the TF1 GetVectorFromWorldPosToSkyboxPos: the world cannon is shrunk into the
// skybox and the barrel is aimed along ship -> cannon.
vector function TF1Port_mp_tf1_outpost_207_StoryAimAngles(int stage)
{
 vector shipOrg = Vector(11906.5300,11874.9300,-11761.9600)
 if(stage == 0)
  shipOrg = Vector(11905.9851,11876.9926,-11762.3357)
 if(stage == 1)
  shipOrg = Vector(11908.8485,11885.9244,-11764.1993)
 if(stage == 2)
  shipOrg = Vector(11906.1199,11885.7598,-11765.8690)
 if(stage == 3)
  shipOrg = Vector(11904.3695,11889.6839,-11768.7777)
 int attach = prop_outpost_cannon_barrel.LookupAttachment("rail_flap_01")
 vector cannonOrg = prop_outpost_cannon_barrel.GetAttachmentOrigin(attach)
 vector mapped = TF1Port_mp_tf1_outpost_207_skycam + cannonOrg * 0.0001
 vector delta = mapped - shipOrg
 return VectorToAngles(Normalize(delta))
}

void function TF1Port_mp_tf1_outpost_207_StoryRotate(vector barrelAngles,float t)
{
 float ramp = t * 0.25
 if(ramp > 1.0)
  ramp = 1.0
 rot_outpost_cannon_barrel.NonPhysicsRotateTo(<barrelAngles.x,barrelAngles.y,0>,t,ramp,ramp)
 rot_outpost_cannon_base.NonPhysicsRotateTo(<0,barrelAngles.y,0>,t,ramp,ramp)
 wait t
}

bool TF1Port_mp_tf1_outpost_207_decoyBusy
bool TF1Port_mp_tf1_outpost_207_decoyDone

// TF1 IntroMain: start at fly-in +6 s; DecoyShip resets for 0.21 s before its warp.
void function TF1Port_mp_tf1_outpost_207_StoryDecoy()
{
 prop_outpost_cannon_barrel.EndSignal("OnDestroy")
 prop_outpost_cannon_base.EndSignal("OnDestroy")
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(6.21)
 TF1Port_mp_tf1_outpost_207_decoyBusy = true
 foreach(entity player in GetPlayerArray())
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1Story_Decoy")
 printt("TF1_DECOY_SERVER_START",Time())
 wait 3.6
 int attach = prop_outpost_cannon_barrel.LookupAttachment("rail_flap_01")
 vector cannonOrg = prop_outpost_cannon_barrel.GetAttachmentOrigin(attach)
 vector target = Vector(-103.1,-12779.8,4500.0)
 thread TF1Port_mp_tf1_outpost_207_StoryRotate(VectorToAngles(Normalize(cannonOrg - target)),13.5)
 wait 2.0
 prop_outpost_cannon_barrel.Anim_Play("flaps_open")
 wait 7.6667
 FlagSet("TF1Port_mp_tf1_outpost_207_DecoyCannonOpen")
 printt("TF1_DECOY_CANNON_OPEN",Time())
 wait 2.3
 prop_outpost_cannon_barrel.Anim_Play("fire")
 printt("TF1_DECOY_CANNON_FIRED")
 wait 4.2
 prop_outpost_cannon_barrel.Anim_Play("flaps_close")
 wait 7.4
 prop_outpost_cannon_barrel.Anim_Play("flaps_close_idle")
 waitthread TF1Port_mp_tf1_outpost_207_StoryRotate(TF1Port_mp_tf1_outpost_207_rest,8.0)
 TF1Port_mp_tf1_outpost_207_decoyBusy = false
 TF1Port_mp_tf1_outpost_207_decoyDone = true
}

bool TF1Port_mp_tf1_outpost_207_cannonBusy
void function TF1Port_mp_tf1_outpost_207_StoryFire(int stage)
{
 prop_outpost_cannon_barrel.EndSignal("OnDestroy")
 prop_outpost_cannon_base.EndSignal("OnDestroy")
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 TF1Port_mp_tf1_outpost_207_cannonBusy = true
 OnThreadEnd(function() : () { TF1Port_mp_tf1_outpost_207_cannonBusy = false })
 if(stage == 1)
 {
  foreach(entity player in GetPlayerArray())
   Remote_CallFunction_NonReplay(player,"ServerCallback_TF1Story_Prepare",17.0)
 }
 waitthread TF1Port_mp_tf1_outpost_207_StoryRotate(TF1Port_mp_tf1_outpost_207_StoryAimAngles(stage - 1),7.0)
 prop_outpost_cannon_barrel.Anim_Play("flaps_open")
 wait 10.0
 prop_outpost_cannon_barrel.Anim_Play("fire")
 FlagSet("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
 printt("TF1_CANNON_FIRED",stage)
 wait 1.1
 TF1Port_mp_tf1_outpost_207_stage = stage
 foreach(entity player in GetPlayerArray())
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1Story_Stage",stage,0)
 printt("TF1_STORY_SHIP_HIT",stage)
 wait 3.1
 prop_outpost_cannon_barrel.Anim_Play("flaps_close")
 wait 7.4
 prop_outpost_cannon_barrel.Anim_Play("flaps_close_idle")
 waitthread TF1Port_mp_tf1_outpost_207_StoryRotate(TF1Port_mp_tf1_outpost_207_rest,7.0)
}


void function TF1Port_mp_tf1_outpost_207_IntroMilitia()
{
 vector refOrg = Vector(-2637.000,859.000,-175.000)
 vector refAng = Vector(0.000,-62.778,0.000)
 entity titan = CreatePropDynamic($"models/titans/atlas/atlas_tf1intro_tf1outpos.mdl",refOrg,refAng)
 titan.SetSkin(1)
 TF1Port_mp_tf1_outpost_207_HideTitanWeakpoints(titan)
 TF1IntroAI_SetNameTag(titan,"tf1_intro_name_mcor_riggins")
 array<entity> grunts
 array<vector> orgs
 array<vector> angs
 array<string> idles
 array<string> plays
 orgs.append(Vector(-2771.000,657.000,-190.000))
 angs.append(Vector(0.000,-60.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_A_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_A_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2771.000,657.000,-190.000),Vector(0,-60.000,0)))
 orgs.append(Vector(-2810.000,657.000,-190.000))
 angs.append(Vector(0.000,-60.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_B_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_B_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2810.000,657.000,-190.000),Vector(0,-60.000,0)))
 orgs.append(Vector(-2900.000,646.000,-190.000))
 angs.append(Vector(0.000,0.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_A_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_A_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2900.000,646.000,-190.000),Vector(0,0.000,0)))
 orgs.append(Vector(-2555.000,1286.000,-190.000))
 angs.append(Vector(0.000,-85.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_B_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_B_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2555.000,1286.000,-190.000),Vector(0,-85.000,0)))
 orgs.append(Vector(-2610.000,1230.000,-190.000))
 angs.append(Vector(0.000,-85.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_A_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_A_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2610.000,1230.000,-190.000),Vector(0,-85.000,0)))
 orgs.append(Vector(-2468.000,1242.000,-190.000))
 angs.append(Vector(0.000,-130.000,0.000))
 idles.append("pt_outpost_MCOR_intro_squad_B_front_idle")
 plays.append("pt_outpost_MCOR_intro_squad_B_front")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2468.000,1242.000,-190.000),Vector(0,-130.000,0)))
 orgs.append(Vector(-2637.000,859.000,-175.000))
 angs.append(Vector(0.000,-62.778,0.000))
 idles.append("pt_outpost_militia_intro_A_idle")
 plays.append("pt_outpost_militia_intro_A")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2853.000,852.000,-190.000),Vector(0,-20.000,0)))
 orgs.append(Vector(-2637.000,859.000,-175.000))
 angs.append(Vector(0.000,-62.778,0.000))
 idles.append("pt_outpost_militia_intro_B_idle")
 plays.append("pt_outpost_militia_intro_B")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2876.000,952.000,-190.000),Vector(0,-55.000,0)))
 orgs.append(Vector(-2637.000,859.000,-175.000))
 angs.append(Vector(0.000,-62.778,0.000))
 idles.append("pt_outpost_militia_intro_C_idle")
 plays.append("pt_outpost_militia_intro_C")
 grunts.append(CreatePropDynamic($"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1intro_tf1outpos.mdl",Vector(-2950.000,849.000,-190.000),Vector(0,-15.000,0)))
 titan.Anim_PlayWithRefPoint("at_outpost_militia_intro_idle",refOrg,refAng,0.0)
 for(int i = 0; i < grunts.len(); i++)
 {
  TF1IntroAI_SetNameTag(grunts[i],"tf1_intro_name_mcor_grunt")
  grunts[i].Anim_PlayWithRefPoint(idles[i],orgs[i],angs[i],0.0)
 }
 printt("TF1_INTRO_MCOR_READY",grunts.len(),titan.LookupSequence("at_outpost_militia_intro"),grunts[0].LookupSequence(plays[0]))
 FlagWait("TF1Port_mp_tf1_outpost_207_DecoyCannonOpen")
 wait 1.0
 titan.Anim_PlayWithRefPoint("at_outpost_militia_intro",refOrg,refAng,0.0)
 for(int i = 0; i < grunts.len(); i++)
 {
  grunts[i].Anim_PlayWithRefPoint(plays[i],orgs[i],angs[i],0.0)
  thread TF1IntroAI_AfterAnimation(grunts[i],TF1_INTRO_AI_GRUNT,TEAM_MILITIA,"militia_grunt",0.0)
 }
 printt("TF1_INTRO_MCOR_PLAY",Time())
 float militiaLength = titan.GetSequenceDuration("at_outpost_militia_intro")
 thread TF1IntroAI_AfterAnimation(titan,TF1_INTRO_AI_TITAN,TEAM_MILITIA,"militia_titan",militiaLength + 0.5)
 wait militiaLength * 0.42505593
 TF1Port_mp_tf1_outpost_207_IntroMilitiaVO(titan,"diag_sp_addtional_TR411_64_mcor_og")
 wait militiaLength * (1.0 - 0.42505593)
 FlagSet("TF1Port_mp_tf1_outpost_207_MilitiaGroundDone")
}

void function TF1Port_mp_tf1_outpost_207_IntroSpectres()
{
 vector consoleOrg = Vector(1604.000,-586.000,-446.000)
 vector consoleAng = Vector(0.000,90.000,0.000)
 entity soldier = CreatePropDynamic($"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1intro_tf1outpos.mdl",consoleOrg,consoleAng)
 TF1IntroAI_SetNameTag(soldier,"tf1_intro_name_imc_keating")
 soldier.Anim_PlayWithRefPoint("pt_outpost_spectre_activation_idle",consoleOrg,consoleAng,0.0)
 array<vector> rackOrg
 array<vector> rackAng
 rackOrg.append(Vector(1719.560,-271.480,-447.000))
 rackAng.append(Vector(0,-90.0000,0))
 rackOrg.append(Vector(1575.560,-271.480,-447.000))
 rackAng.append(Vector(0,-90.0000,0))
 rackOrg.append(Vector(1371.480,-450.440,-447.000))
 rackAng.append(Vector(0,0.0000,0))
 rackOrg.append(Vector(1371.480,-330.440,-447.000))
 rackAng.append(Vector(0,0.0000,0))
 rackOrg.append(Vector(3976.230,-338.163,-714.001))
 rackAng.append(Vector(0,-40.7372,0))
 rackOrg.append(Vector(3923.880,-437.153,-714.001))
 rackAng.append(Vector(0,12.5624,0))
 rackOrg.append(Vector(4289.640,-1130.910,-705.677))
 rackAng.append(Vector(0,107.5490,0))
 rackOrg.append(Vector(4184.950,-1066.620,-705.677))
 rackAng.append(Vector(0,66.9445,0))
 array<entity> spectres
 for(int i = 0; i < rackOrg.len(); i++)
 {
  entity s = CreatePropDynamic($"models/robots/spectre/spectre_tf1intro_tf1outpos.mdl",rackOrg[i],rackAng[i])
  s.Anim_PlayWithRefPoint("sp_med_bay_dropidle_A",rackOrg[i],rackAng[i],0.0)
  spectres.append(s)
 }
 printt("TF1_INTRO_SPECTRES_READY",spectres.len(),soldier.LookupSequence("pt_outpost_spectre_activation"),spectres[0].LookupSequence("sp_med_bay_drop_armed"))
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(16.0)
 float delay = 0.0
 for(int i = rackOrg.len() - 1; i >= 4; i--)
 {
  wait delay
  delay += RandomFloatRange(0.5,0.75)
  spectres[i].Anim_PlayWithRefPoint("sp_med_bay_drop_armed",rackOrg[i],rackAng[i],0.0)
  TF1IntroAI_SetNameTag(spectres[i],"tf1_intro_name_imc_pad_spectre")
  thread TF1IntroAI_AfterAnimation(spectres[i],TF1_INTRO_AI_SPECTRE,TEAM_IMC,"spectre_pad",0.0)
  printt("TF1_INTRO_PAD_SPECTRE",i,Time())
 }
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(33.0)
 soldier.Anim_PlayWithRefPoint("pt_outpost_spectre_activation",consoleOrg,consoleAng,0.0)
 thread TF1IntroAI_AfterAnimation(soldier,TF1_INTRO_AI_GRUNT,TEAM_IMC,"imc_console",5.25)
 printt("TF1_INTRO_SPECTRES_PLAY",Time())
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(38.0)
 TF1Port_mp_tf1_outpost_207_IntroImcVO(soldier,"diag_sp_addtional_TR411_62_mcor_og")
 delay = 0.0
 for(int i = 0; i < 4; i++)
 {
  wait delay
  delay += RandomFloatRange(0.2,0.3)
  spectres[i].Anim_PlayWithRefPoint("sp_med_bay_drop_armed",rackOrg[i],rackAng[i],0.0)
  TF1IntroAI_SetNameTag(spectres[i],"tf1_intro_name_imc_lab_spectre")
  thread TF1IntroAI_AfterAnimation(spectres[i],TF1_INTRO_AI_SPECTRE,TEAM_IMC,"spectre_lab",0.0)
  printt("TF1_INTRO_LAB_SPECTRE",i,Time())
 }
}

table<entity,array<entity> > TF1Port_mp_tf1_outpost_207_introMcor
table<entity,array<entity> > TF1Port_mp_tf1_outpost_207_introImc
table<entity,float> TF1Port_mp_tf1_outpost_207_introJump
table<entity,float> TF1Port_mp_tf1_outpost_207_introTakeoff
float TF1Port_mp_tf1_outpost_207_introStart

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Register()
{
 if(!TF1Port_mp_tf1_outpost_207_CampaignEnabled())return
 FlagInit("TF1Port_mp_tf1_outpost_207_IntroFlightStarted")
 // Northstar uses zero advertised length for cinematics without the MP countdown.
 ClassicMP_SetLevelIntro(TF1Port_mp_tf1_outpost_207_TF1Intro_Setup,0.0)
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Setup()
{
 AddCallback_OnClientConnected(TF1Port_mp_tf1_outpost_207_TF1Intro_OnConnected)
 AddCallback_GameStateEnter(eGameState.Prematch,TF1Port_mp_tf1_outpost_207_TF1Intro_Prematch)
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_OnConnected(entity player)
{
 if(GetGameState() != eGameState.Prematch)
  return
 if(PlayerCanSpawn(player))
  DoRespawnPlayer(player,null)
 TF1Port_mp_tf1_outpost_207_TF1Intro_Seat(player)
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Prematch()
{
 thread TF1Port_mp_tf1_outpost_207_TF1Intro_Run()
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Run()
{
 FlagWait("EntitiesDidLoad")
 TF1Port_mp_tf1_outpost_207_introMatchStart = Time()
 ClassicMP_OnIntroStarted()
 foreach ( entity player in GetPlayerArray() )
 {
  if ( IsValid( player ) )
   Remote_CallFunction_NonReplay( player, "ServerCallback_TF1OutpostIntroScreen" )
 }
 printt( "TF1_OUTPOST_INTRO_SCREEN_SENT", Time() )
 thread TF1Port_mp_tf1_outpost_207_IntroConversations()
 wait 19.0
 TF1Port_mp_tf1_outpost_207_introStart = Time()
 FlagSet("TF1Port_mp_tf1_outpost_207_IntroFlightStarted")
 TF1Port_mp_tf1_outpost_207_introMcor.clear()
 TF1Port_mp_tf1_outpost_207_introImc.clear()
 TF1Port_mp_tf1_outpost_207_introJump.clear()
 TF1Port_mp_tf1_outpost_207_introTakeoff.clear()
 TF1Port_mp_tf1_outpost_207_TF1IntroShip(TEAM_MILITIA,$"models/vehicle/crow_dropship/crow_dropship_tf1intro_tf1outpos.mdl",Vector(-2637.000,859.000,-175.000),Vector(0.000,-62.778,0.000),"dropship_outpost_flyin_mcor_L",16.40,24.57,19.87,9.5000)
 TF1Port_mp_tf1_outpost_207_TF1IntroShip(TEAM_MILITIA,$"models/vehicle/crow_dropship/crow_dropship_tf1intro_tf1outpos.mdl",Vector(-2637.000,859.000,-175.000),Vector(0.000,-62.778,0.000),"dropship_outpost_flyin_mcor_R",16.97,24.57,19.97,9.5000)
 TF1Port_mp_tf1_outpost_207_TF1IntroShip(TEAM_IMC,$"models/vehicle/goblin_dropship/goblin_dropship_tf1intro_tf1outpos.mdl",Vector(4384.000,-708.000,-702.000),Vector(0.000,180.000,0.000),"dropship_outpost_flyin_IMC_L",18.13,25.37,19.70,9.6667)
 TF1Port_mp_tf1_outpost_207_TF1IntroShip(TEAM_IMC,$"models/vehicle/goblin_dropship/goblin_dropship_tf1intro_tf1outpos.mdl",Vector(4384.000,-708.000,-702.000),Vector(0.000,180.000,0.000),"dropship_outpost_flyin_IMC_R",17.70,24.93,19.43,9.6667)
 printt("TF1_DROPSHIP_INTRO_START",TF1Port_mp_tf1_outpost_207_introMcor.len(),TF1Port_mp_tf1_outpost_207_introImc.len(),TF1Port_mp_tf1_outpost_207_introStart)
 foreach(entity player in GetPlayerArray())
 {
  if(IsPrivateMatchSpectator(player))
  {
   RespawnPrivateMatchSpectator(player)
   continue
  }
  if(PlayerCanSpawn(player))
   DoRespawnPlayer(player,null)
  TF1Port_mp_tf1_outpost_207_TF1Intro_Seat(player)
 }
 wait 26.4
 FlagSet("TF1Port_mp_tf1_outpost_207_MilitiaLanded")
 FlagSet("TF1Port_mp_tf1_outpost_207_IMCLanded")
 TF1Port_mp_tf1_outpost_207_TF1Intro_StartPlaying()
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_StartPlaying()
{
 if(GetGameState() != eGameState.Prematch)
  return
 if(!TF1IntroAI_MatchGateOpen())
  return
 float elapsed = Time() - TF1Port_mp_tf1_outpost_207_introMatchStart
 SetServerVar("gameEndTime",expect float(GetServerVar("gameEndTime")) + elapsed)
 SetServerVar("roundEndTime",expect float(GetServerVar("roundEndTime")) + elapsed)
 ClassicMP_OnIntroFinished()
 thread TF1IntroAI_AnnounceMode()
 SetServerVar("gameStartTime",Time())
 SetServerVar("roundStartTime",Time())
 printt("TF1_GAMEPLAY_STARTED",Time() - TF1Port_mp_tf1_outpost_207_introStart)
}

void function TF1Port_mp_tf1_outpost_207_TF1IntroShip(int team,asset model,vector org,vector ang,string anim,float jump,float length,float takeoff,float rampOpen)
{
 entity ship = CreatePropDynamic(model,org,ang)
 ship.SetFadeDistance(60000)
 ship.EnableRenderAlways()
 ship.Anim_PlayWithRefPoint(anim,org,ang,0.0)
 EmitSoundOnEntity(ship,"dropship_warpin")
 thread TF1Port_mp_tf1_outpost_207_IntroShipFlyinAudio(ship,team)
 if(team == TEAM_MILITIA)
  TF1Port_mp_tf1_outpost_207_introMcor[ship] <- [null,null,null,null]
 else
  TF1Port_mp_tf1_outpost_207_introImc[ship] <- [null,null,null,null]
 TF1Port_mp_tf1_outpost_207_introJump[ship] <- jump
 TF1Port_mp_tf1_outpost_207_introTakeoff[ship] <- takeoff
 TF1IntroAI_rampOpenTimes[ship] <- rampOpen
 thread TF1Port_mp_tf1_outpost_207_TF1IntroCrew(ship,team,rampOpen)
 thread TF1Port_mp_tf1_outpost_207_IntroShipDepartureAudio(ship,team,takeoff)
 thread TF1Port_mp_tf1_outpost_207_TF1IntroShipEnd(ship,length)
}

void function TF1Port_mp_tf1_outpost_207_TF1IntroCrew(entity ship,int team,float rampOpen)
{
 ship.EndSignal("OnDestroy")
 array<entity> crew
 OnThreadEnd(
  function() : (crew)
  {
   foreach(entity actor in crew)
    if(IsValid(actor))
     actor.Destroy()
  }
 )
 bool militia = team == TEAM_MILITIA
 asset heroModel = militia ? $"models/humans/mcor_hero/sarah/sarah_tf1intro_tf1outpos.mdl" : $"models/humans/imc_villain/spyglass/spyglass_tf1intro_tf1outpos.mdl"
 asset pilotModel = militia ? $"models/humans/mcor_grunt/battle_rifle/mcor_grunt_tf1cockpit_tf1outpos.mdl" : $"models/humans/imc_grunt/battle_rifle/imc_grunt_tf1cockpit_tf1outpos.mdl"
 string heroAnim = militia ? "tf1op207_sarah_intro" : "tf1op207_spyglass_intro"
 array<asset> models = [heroModel,pilotModel]
 array<string> anims = [heroAnim,"Militia_flyinA_idle_mac"]
 for(int i = 0; i < models.len(); i++)
 {
  entity actor = CreatePropDynamic(models[i],ship.GetOrigin(),ship.GetAngles())
  crew.append(actor)
  actor.SetParent(ship,"ORIGIN")
  actor.MarkAsNonMovingAttachment()
  actor.LerpSkyScale(militia ? 0.5 : 0.4,0.1)
  Assert(actor.LookupSequence(anims[i]) >= 0)
  thread PlayAnimTeleport(actor,anims[i],ship,"ORIGIN")
  if(i == 0)
   thread TF1Port_mp_tf1_outpost_207_IntroActorAudio(actor,militia)
  printt("TF1_DROPSHIP_CREW",team,anims[i],actor.LookupSequence(anims[i]))
 }
 wait max(0.0,TF1Port_mp_tf1_outpost_207_introStart + rampOpen - Time())
 TF1IntroAI_RampWind(ship)
 thread TF1Port_mp_tf1_outpost_207_IntroDoorAudio(ship)
 foreach(entity actor in crew)
  actor.LerpSkyScale(militia ? 1.0 : 0.9,1.0)
 ship.WaitSignal("OnDestroy")
}

void function TF1Port_mp_tf1_outpost_207_TF1IntroShipEnd(entity ship,float length)
{
 wait length
 if(IsValid(ship))
  ship.Destroy()
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Seat(entity player)
{
 if(Dev_CommandLineHasParm("-tf1_intro_imc"))
 {
  SetTeam(player,TEAM_IMC)
  printt("TF1_DROPSHIP_TEST_TEAM","IMC",player.GetTeam())
 }
 table<entity,array<entity> > ships = player.GetTeam() == TEAM_MILITIA ? TF1Port_mp_tf1_outpost_207_introMcor : TF1Port_mp_tf1_outpost_207_introImc
 entity chosen
 int seat = RandomInt(4)
 array<entity> all
 foreach(entity ship,array<entity> slots in ships)
 {
  all.append(ship)
  if(IsValid(chosen))
   continue
  array<int> free
  for(int i = 0; i < 4; i++)
   if(!IsValidPlayer(slots[i]))
    free.append(i)
  if(free.len() == 0)
   continue
  seat = free.getrandom()
  slots[seat] = player
  chosen = ship
 }
 if(!IsValid(chosen) && all.len() > 0)
  chosen = all.getrandom()
 if(IsValid(chosen))
  thread TF1Port_mp_tf1_outpost_207_TF1Intro_Ride(player,seat,chosen)
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Ride(entity player,int seat,entity ship)
{
 player.EndSignal("OnDestroy")
 player.EndSignal("OnDeath")
 array<string> idle3 = ["Classic_MP_flyin_exit_playerA_idle","Classic_MP_flyin_exit_playerB_idle","Classic_MP_flyin_exit_playerC_idle","Classic_MP_flyin_exit_playerD_idle"]
 array<string> idle1 = ["Classic_MP_flyin_exit_povA_idle","Classic_MP_flyin_exit_povB_idle","Classic_MP_flyin_exit_povC_idle","Classic_MP_flyin_exit_povD_idle"]
 array<string> jump3 = ["Classic_MP_flyin_exit_playerA_jump","Classic_MP_flyin_exit_playerB_jump","Classic_MP_flyin_exit_playerC_jump","Classic_MP_flyin_exit_playerD_jump"]
 array<string> jump1 = ["Classic_MP_flyin_exit_povA_jump","Classic_MP_flyin_exit_povB_jump","Classic_MP_flyin_exit_povC_jump","Classic_MP_flyin_exit_povD_jump"]
 float jumpLength = player.GetSequenceDuration(jump3[seat])
 Assert(jumpLength > 0.0)
 float releaseBy = TF1Port_mp_tf1_outpost_207_introStart + TF1Port_mp_tf1_outpost_207_introTakeoff[ship] - 0.5
 if(Time() >= releaseBy)
 {
  printt("TF1_DROPSHIP_SKIP_LATE",player.GetTeam(),seat)
  return
 }
 float jumpAt = min(TF1Port_mp_tf1_outpost_207_introStart + TF1Port_mp_tf1_outpost_207_introJump[ship],releaseBy - jumpLength)
 printt("TF1_DROPSHIP_TIMING",player.GetTeam(),seat,jumpLength,jumpAt - TF1Port_mp_tf1_outpost_207_introStart,releaseBy - TF1Port_mp_tf1_outpost_207_introStart)
 OnThreadEnd(
  function() : (player)
  {
   if(IsValid(player))
   {
    player.ClearParent()
    ClearPlayerAnimViewEntity(player)
   }
  }
 )
 HolsterAndDisableWeapons(player)
 player.DisableWeaponViewModel()
 UnMuteAll(player)
 StopSoundOnEntity(player,"Duck_For_FrontierDefenseTitanSelectScreen")
 AddCinematicFlag(player,CE_FLAG_CLASSIC_MP_SPAWNING)
 ScreenFadeFromBlack(player,0.5,0.5)
 if(IsValid(ship) && jumpAt - Time() > 0.05)
 {
  FirstPersonSequenceStruct idle
  idle.firstPersonAnim = idle1[seat]
  idle.thirdPersonAnim = idle3[seat]
  idle.attachment = "ORIGIN"
  idle.teleport = true
  idle.viewConeFunction = ViewConeRampFree
  idle.hideProxy = true
  thread FirstPersonSequence(idle,player,ship)
  entity proxy = player.GetFirstPersonProxy()
  Assert(IsValid(proxy))
  float idleLength = max(player.GetSequenceDuration(idle3[seat]),proxy.GetSequenceDuration(idle1[seat]))
  Assert(idleLength > 0.0)
  printt("TF1_DROPSHIP_VIEW_INIT",player.GetTeam(),seat)
  thread TF1IntroAI_RampBloom(player,ship,TF1IntroAI_rampOpenTimes[ship],jumpAt)
  // Hide the particle's onset until the final 0.5 seconds of TF1's 2.2-second lead.
  ScreenFadeFromColor(player,255,255,255,255,0.5,1.7)
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1OutpostWarpArrival")
  printt("TF1_INTRO_WARP_SCREEN",player.GetTeam(),seat,Time())
  wait min(idleLength,max(0.0,jumpAt - Time()))
  // Keep the same view entity and free-look offset; only repeat the parented animations.
  while(IsValid(ship) && IsValid(proxy) && jumpAt - Time() > 0.05)
  {
   player.Anim_Play(idle3[seat])
   proxy.Anim_Play(idle1[seat])
   printt("TF1_DROPSHIP_IDLE_REPEAT",player.GetTeam(),seat)
   wait min(idleLength,max(0.0,jumpAt - Time()))
  }
 }
 printt("TF1_DROPSHIP_JUMP",player,seat,Time() - TF1Port_mp_tf1_outpost_207_introStart,IsValid(ship) ? ship.GetOrigin() : <0,0,0>)
 FirstPersonSequenceStruct jump
 jump.firstPersonAnim = jump1[seat]
 jump.thirdPersonAnim = jump3[seat]
 jump.attachment = "ORIGIN"
 jump.viewConeFunction = ViewConeFree
 jump.setInitialTime = max(0.0,Time() - jumpAt)
 if(IsValid(ship))
  waitthread FirstPersonSequence(jump,player,ship)
 printt("TF1_DROPSHIP_RELEASE",player.GetTeam(),seat,Time() - TF1Port_mp_tf1_outpost_207_introStart,releaseBy - TF1Port_mp_tf1_outpost_207_introStart)
 thread TF1Port_mp_tf1_outpost_207_TF1Intro_Land(player)
}

void function TF1Port_mp_tf1_outpost_207_TF1Intro_Land(entity player)
{
 player.EndSignal("OnDeath")
 player.EndSignal("OnDestroy")
 OnThreadEnd(
  function() : (player)
  {
   if(IsValid(player))
   {
    player.MovementEnable()
    player.EnableWeaponViewModel()
    DeployAndEnableWeapons(player)
    RemoveCinematicFlag(player,CE_FLAG_CLASSIC_MP_SPAWNING)
   }
  }
 )
 player.ClearParent()
 WaitFrame()
 player.SetVelocity(<0,0,-100>)
 player.MovementDisable()
 player.ConsumeDoubleJump()
 WaitFrame()
 while(!player.IsOnGround() && !player.IsWallRunning() && !player.IsWallHanging())
  WaitFrame()
 TF1Port_mp_tf1_outpost_207_TF1Intro_StartPlaying()
}


array<bool> TF1Port_mp_tf1_outpost_207_militiaDone = [false,false,false,false]
array<bool> TF1Port_mp_tf1_outpost_207_imcDone = [false,false,false,false]
bool TF1Port_mp_tf1_outpost_207_halfEvent
bool TF1Port_mp_tf1_outpost_207_campaignEnded
int TF1Port_mp_tf1_outpost_207_outcome
float TF1Port_mp_tf1_outpost_207_introMatchStart

bool function TF1Port_mp_tf1_outpost_207_CampaignEnabled()
{
 return GetMapName() == "mp_tf1_outpost_207" && (GAMETYPE == "aitdm" || GAMETYPE == "tdm")
}

void function TF1Port_mp_tf1_outpost_207_Conversation(string name,int team)
{
 int id = -1
 if(name == "Intro_FlyIn_MCOR" && team == TEAM_MILITIA)id = 0
 if(name == "Intro_FlyIn_MCOR_pt2" && team == TEAM_MILITIA)id = 1
 if(name == "Intro_FlyIn_IMC" && team == TEAM_IMC)id = 2
 if(name == "Intro_FlyIn_IMC_pt2" && team == TEAM_IMC)id = 3
 if(name == "Intro_PostFlyIn_MCOR" && team == TEAM_MILITIA)id = 4
 if(name == "Intro_PostFlyIn_MCOR_pt2" && team == TEAM_MILITIA)id = 5
 if(name == "Intro_PostFlyIn_IMC" && team == TEAM_IMC)id = 6
 if(name == "Intro_PostFlyIn_IMC_pt2" && team == TEAM_IMC)id = 7
 if(name == "JumpDrivesDisabled" && team == TEAM_MILITIA)id = 8
 if(name == "JumpDrivesDisabled_pt2" && team == TEAM_MILITIA)id = 9
 if(name == "JumpDrivesDisabled_pt2_mcorWinning" && team == TEAM_MILITIA)id = 10
 if(name == "JumpDrivesDisabled_pt2_imcWinning" && team == TEAM_MILITIA)id = 11
 if(name == "JumpDrivesDisabled" && team == TEAM_IMC)id = 12
 if(name == "JumpDrivesDisabled_pt2" && team == TEAM_IMC)id = 13
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore" && team == TEAM_MILITIA)id = 14
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore_AfterIMC" && team == TEAM_MILITIA)id = 15
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore_pt2" && team == TEAM_MILITIA)id = 16
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore_AfterIMC_pt2" && team == TEAM_MILITIA)id = 17
 if(name == "Gamestate_QuarterScore_IMC_ReachedScore" && team == TEAM_MILITIA)id = 18
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore" && team == TEAM_IMC)id = 19
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore_pt2" && team == TEAM_IMC)id = 20
 if(name == "Gamestate_QuarterScore_MCOR_ReachedScore_AfterIMC_pt2" && team == TEAM_IMC)id = 21
 if(name == "Gamestate_QuarterScore_IMC_ReachedScore" && team == TEAM_IMC)id = 22
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore" && team == TEAM_MILITIA)id = 23
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_AfterIMC" && team == TEAM_MILITIA)id = 24
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_pt2" && team == TEAM_MILITIA)id = 25
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_AfterIMC_pt2" && team == TEAM_MILITIA)id = 26
 if(name == "Gamestate_HalfScore_IMC_ReachedScore" && team == TEAM_MILITIA)id = 27
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore" && team == TEAM_IMC)id = 28
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_AfterIMC" && team == TEAM_IMC)id = 29
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_pt2" && team == TEAM_IMC)id = 30
 if(name == "Gamestate_HalfScore_MCOR_ReachedScore_AfterIMC_pt2" && team == TEAM_IMC)id = 31
 if(name == "Gamestate_HalfScore_IMC_ReachedScore" && team == TEAM_IMC)id = 32
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore" && team == TEAM_MILITIA)id = 33
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore_AfterIMC" && team == TEAM_MILITIA)id = 34
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore_pt2" && team == TEAM_MILITIA)id = 35
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore_AfterIMC_pt2" && team == TEAM_MILITIA)id = 36
 if(name == "Gamestate_ThreeQuarterScore_IMC_ReachedScore" && team == TEAM_MILITIA)id = 37
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore" && team == TEAM_IMC)id = 38
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore_AfterIMC" && team == TEAM_IMC)id = 39
 if(name == "Gamestate_ThreeQuarterScore_MCOR_ReachedScore_pt2" && team == TEAM_IMC)id = 40
 if(name == "Gamestate_ThreeQuarterScore_IMC_ReachedScore" && team == TEAM_IMC)id = 41
 if(name == "Epilogue_MatchWon" && team == TEAM_MILITIA)id = 42
 if(name == "Epilogue_MatchWon_pt2" && team == TEAM_MILITIA)id = 43
 if(name == "Epilogue_MatchLost" && team == TEAM_MILITIA)id = 44
 if(name == "Epilogue_MatchWon" && team == TEAM_IMC)id = 45
 if(name == "Epilogue_MatchLost" && team == TEAM_IMC)id = 46
 if(name == "Epilogue_Lifeboat1" && team == TEAM_IMC)id = 47
 if(name == "Epilogue_Lifeboat2" && team == TEAM_IMC)id = 48
 if(name == "Epilogue_Lifeboat3" && team == TEAM_IMC)id = 49
 if(name == "Epilogue_Lifeboat4" && team == TEAM_IMC)id = 50
 if(name == "PostEpilogue" && team == TEAM_IMC)id = 51
 if(name == "PostEpilogue" && team == TEAM_MILITIA)id = 52
 if(name == "EscapeShipIMC" && team == TEAM_IMC)id = 53
 if(id < 0)
 {
  printt("TF1_OUTPOST_CONVERSATION_UNAVAILABLE",name,team)
  return
 }
 foreach(entity player in GetPlayerArrayOfTeam(team))
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1OutpostConversation",id)
 printt("TF1_OUTPOST_CONVERSATION",name,team,Time())
}

void function TF1Port_mp_tf1_outpost_207_ConversationBoth(string name)
{
 TF1Port_mp_tf1_outpost_207_Conversation(name,TEAM_MILITIA)
 TF1Port_mp_tf1_outpost_207_Conversation(name,TEAM_IMC)
}

void function TF1Port_mp_tf1_outpost_207_CampaignInit()
{
 if(!TF1Port_mp_tf1_outpost_207_CampaignEnabled())return
 FlagInit("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
 FlagInit("TF1Port_mp_tf1_outpost_207_DecoyDestroyed")
 FlagInit("TF1Port_mp_tf1_outpost_207_MilitiaGroundDone")
 FlagInit("TF1Port_mp_tf1_outpost_207_MilitiaLanded")
 FlagInit("TF1Port_mp_tf1_outpost_207_IMCLanded")
 RegisterSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 AddCallback_GameStateEnter(eGameState.WinnerDetermined,TF1Port_mp_tf1_outpost_207_CampaignEnd)
 printt("TF1_OUTPOST_CAMPAIGN_READY","native-timer-preserved","score-only-milestones")
}

void function TF1Port_mp_tf1_outpost_207_IntroConversations()
{
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 wait max(0.0,TF1Port_mp_tf1_outpost_207_introMatchStart + 3.0 - Time())
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_FlyIn_MCOR",TEAM_MILITIA)
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_FlyIn_IMC",TEAM_IMC)
 wait max(0.0,TF1Port_mp_tf1_outpost_207_introMatchStart + 29.0 - Time())
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_FlyIn_MCOR_pt2",TEAM_MILITIA)
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_FlyIn_IMC_pt2",TEAM_IMC)
 FlagWait("TF1Port_mp_tf1_outpost_207_DecoyDestroyed")
 wait 2.0
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_PostFlyIn_IMC",TEAM_IMC)
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_PostFlyIn_MCOR",TEAM_MILITIA)
 FlagWait("TF1Port_mp_tf1_outpost_207_IMCLanded")
 float imcDoneAt = Time() + 10.9
 FlagWait("TF1Port_mp_tf1_outpost_207_MilitiaLanded")
 FlagWait("TF1Port_mp_tf1_outpost_207_MilitiaGroundDone")
 wait max(0.0,imcDoneAt - Time())
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_PostFlyIn_MCOR_pt2",TEAM_MILITIA)
 wait 1.5
 TF1Port_mp_tf1_outpost_207_Conversation("Intro_PostFlyIn_IMC_pt2",TEAM_IMC)
}

void function TF1Port_mp_tf1_outpost_207_DecoyDestroyedLater()
{
 waitthread TF1Port_mp_tf1_outpost_207_IntroWait(22.11)
 FlagSet("TF1Port_mp_tf1_outpost_207_DecoyDestroyed")
}

// Native Northstar exposes SetTimerBased but no getter. Do not infer timer policy from gameEndTime.
void function TF1Port_mp_tf1_outpost_207_CampaignWatch()
{
 if(Dev_CommandLineHasParm("-tf1_story_demo"))
 {
  printt("TF1_OUTPOST_DEMO","diagnostic-cannon-only")
  waitthread TF1Port_mp_tf1_outpost_207_CampaignDemoWatch()
  return
 }
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 array<int> marks = [5,25,50,75]
 while(!TF1Port_mp_tf1_outpost_207_campaignEnded)
 {
  wait 0.1
  if(GetGameState() != eGameState.Playing || TF1Port_mp_tf1_outpost_207_decoyBusy || !TF1Port_mp_tf1_outpost_207_decoyDone)continue
  int limit = GameMode_GetScoreLimit(GAMETYPE)
  if(limit <= 0)
  {
   printt("TF1_OUTPOST_INVALID_SCORE_LIMIT",limit)
   return
  }
  int militia = GameRules_GetTeamScore(TEAM_MILITIA)
  int imc = GameRules_GetTeamScore(TEAM_IMC)
  for(int i = 0; i < marks.len(); i++)
  {
   if(TF1Port_mp_tf1_outpost_207_militiaDone[i])continue
   float required = float(limit) * float(marks[i]) * 0.01
   int team = TEAM_UNASSIGNED
   if(float(militia) >= required)team = TEAM_MILITIA
   else if(float(imc) >= required)team = TEAM_IMC
   if(team == TEAM_UNASSIGNED || (team == TEAM_IMC && TF1Port_mp_tf1_outpost_207_imcDone[i]))break
   bool first = !TF1Port_mp_tf1_outpost_207_imcDone[i]
   if(team == TEAM_MILITIA || i == 0)TF1Port_mp_tf1_outpost_207_militiaDone[i] = true
   if(team == TEAM_IMC || i == 0)TF1Port_mp_tf1_outpost_207_imcDone[i] = true
   // Preserve the source quirk: the half-event sets this flag even on the IMC branch.
   if(i == 2)TF1Port_mp_tf1_outpost_207_halfEvent = true
   printt("TF1_OUTPOST_MILESTONE",marks[i],team,first)
   waitthread TF1Port_mp_tf1_outpost_207_CampaignMilestone(i,team,first)
   break
  }
 }
}

void function TF1Port_mp_tf1_outpost_207_CampaignMilestone(int index,int team,bool first)
{
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 if(index == 0)
 {
  wait 12.25
  TF1Port_mp_tf1_outpost_207_Conversation("JumpDrivesDisabled",TEAM_IMC)
  thread TF1Port_mp_tf1_outpost_207_DelayedConversation("JumpDrivesDisabled",TEAM_MILITIA,3.0)
  wait 5.0
  FlagClear("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
  thread TF1Port_mp_tf1_outpost_207_StoryFire(1)
  FlagWait("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
  wait 7.0
  TF1Port_mp_tf1_outpost_207_ConversationBoth("JumpDrivesDisabled_pt2")
  wait 5.0
  bool winning = GameRules_GetTeamScore(TEAM_MILITIA) >= GameRules_GetTeamScore(TEAM_IMC)
  TF1Port_mp_tf1_outpost_207_Conversation(winning ? "JumpDrivesDisabled_pt2_mcorWinning" : "JumpDrivesDisabled_pt2_imcWinning",TEAM_MILITIA)
  wait winning ? 4.0 : 8.0
 }
 else
 {
  array<string> names = ["Quarter","Half","ThreeQuarter"]
  string stem = "Gamestate_" + names[index - 1] + "Score_"
  if(team == TEAM_IMC)
  {
   TF1Port_mp_tf1_outpost_207_ConversationBoth(stem + "IMC_ReachedScore")
   wait index == 3 ? 15.0 : 10.0
   return
  }
  string normal = stem + "MCOR_ReachedScore"
  string alternate = normal + "_AfterIMC"
  if(index == 1)
  {
   TF1Port_mp_tf1_outpost_207_Conversation(normal,TEAM_IMC)
   if(!first)wait 1.0
   TF1Port_mp_tf1_outpost_207_Conversation(first ? normal : alternate,TEAM_MILITIA)
   wait first ? 9.0 : 7.0
  }
  else if(index == 2)
  {
   TF1Port_mp_tf1_outpost_207_Conversation(first ? normal : alternate,TEAM_MILITIA)
   wait first ? 4.0 : 2.0
   TF1Port_mp_tf1_outpost_207_Conversation(first ? normal : alternate,TEAM_IMC)
   wait first ? 6.0 : 4.0
  }
  else
  {
   TF1Port_mp_tf1_outpost_207_Conversation(first ? normal : alternate,TEAM_IMC)
   if(!first)wait 5.0
   TF1Port_mp_tf1_outpost_207_Conversation(first ? normal : alternate,TEAM_MILITIA)
   wait first ? 6.0 : 5.0
  }
  FlagClear("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
  thread TF1Port_mp_tf1_outpost_207_StoryFire(index + 1)
  FlagWait("TF1Port_mp_tf1_outpost_207_CampaignCannonFired")
  wait 5.0
  TF1Port_mp_tf1_outpost_207_Conversation((first ? normal : alternate) + "_pt2",TEAM_MILITIA)
  TF1Port_mp_tf1_outpost_207_Conversation((index == 3 ? normal : (first ? normal : alternate)) + "_pt2",TEAM_IMC)
  wait index == 2 && first ? 12.0 : 10.0
 }
 while(TF1Port_mp_tf1_outpost_207_cannonBusy)wait 0.1
}

void function TF1Port_mp_tf1_outpost_207_DelayedConversation(string name,int team,float delay)
{
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 wait delay
 TF1Port_mp_tf1_outpost_207_Conversation(name,team)
}

void function TF1Port_mp_tf1_outpost_207_CampaignEnd()
{
 if(TF1Port_mp_tf1_outpost_207_campaignEnded)return
 TF1Port_mp_tf1_outpost_207_campaignEnded = true
 prop_outpost_cannon_barrel.Signal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 int winner = GetWinningTeam()
 if(winner != TEAM_MILITIA && winner != TEAM_IMC)
 {
  printt("TF1_OUTPOST_DRAW","native-result-preserved")
  return
 }
 TF1Port_mp_tf1_outpost_207_outcome = winner == TEAM_MILITIA ? 1 : (TF1Port_mp_tf1_outpost_207_halfEvent ? 4 : 3)
 foreach(entity player in GetPlayerArray())
  Remote_CallFunction_NonReplay(player,"ServerCallback_TF1OutpostOutcome",TF1Port_mp_tf1_outpost_207_outcome,0)
 TF1Port_mp_tf1_outpost_207_Conversation("Epilogue_MatchWon",winner)
 TF1Port_mp_tf1_outpost_207_Conversation("Epilogue_MatchLost",GetOtherTeam(winner))
 printt("TF1_OUTPOST_OUTCOME",winner,TF1Port_mp_tf1_outpost_207_outcome,"evac-team",GetOtherTeam(winner))
 thread TF1Port_mp_tf1_outpost_207_CampaignEnding(winner)
 thread TF1Port_mp_tf1_outpost_207_CampaignEndConversations(winner)
}

void function TF1Port_mp_tf1_outpost_207_CampaignEndConversations(int winner)
{
 if(winner == TEAM_MILITIA)
 {
  wait 17.5
  TF1Port_mp_tf1_outpost_207_Conversation("Epilogue_MatchWon_pt2",TEAM_MILITIA)
  wait 8.5
  TF1Port_mp_tf1_outpost_207_Conversation("PostEpilogue",TEAM_MILITIA)
  wait 1.0
  TF1Port_mp_tf1_outpost_207_Conversation("PostEpilogue",TEAM_IMC)
 }
 else
 {
  wait 13.0
  TF1Port_mp_tf1_outpost_207_Conversation("EscapeShipIMC",TEAM_IMC)
  wait 13.5
  TF1Port_mp_tf1_outpost_207_Conversation("PostEpilogue",TEAM_MILITIA)
  wait 7.0
  TF1Port_mp_tf1_outpost_207_Conversation("PostEpilogue",TEAM_IMC)
 }
}

void function TF1Port_mp_tf1_outpost_207_CampaignEnding(int winner)
{
 if(winner == TEAM_MILITIA)
 {
  wait 2.0
  waitthread TF1Port_mp_tf1_outpost_207_StoryRotate(TF1Port_mp_tf1_outpost_207_StoryAimAngles(TF1Port_mp_tf1_outpost_207_stage > 3 ? 3 : TF1Port_mp_tf1_outpost_207_stage),7.0)
  prop_outpost_cannon_barrel.Anim_Play("flaps_open")
  wait 10.0
  prop_outpost_cannon_barrel.Anim_Play("fire")
  wait 1.1
  TF1Port_mp_tf1_outpost_207_outcome = 2
  foreach(entity player in GetPlayerArray())
   Remote_CallFunction_NonReplay(player,"ServerCallback_TF1OutpostOutcome",2,0)
  wait 3.1
  prop_outpost_cannon_barrel.Anim_Play("flaps_close")
  wait 7.4
  prop_outpost_cannon_barrel.Anim_Play("flaps_close_idle")
  waitthread TF1Port_mp_tf1_outpost_207_StoryRotate(TF1Port_mp_tf1_outpost_207_rest,7.0)
 }
}

void function TF1Port_mp_tf1_outpost_207_CampaignDemoWatch()
{
 prop_outpost_cannon_barrel.EndSignal("TF1Port_mp_tf1_outpost_207_CampaignEnded")
 int stage = 0
 bool demo = Dev_CommandLineHasParm("-tf1_story_demo")
 float nextDemo = Time() + 25.0
 while(stage < 4)
 {
  wait 2.0
  if(GetGameState() != eGameState.Playing)
   continue
  if(TF1Port_mp_tf1_outpost_207_decoyBusy || !TF1Port_mp_tf1_outpost_207_decoyDone)
  {
   nextDemo = Time() + 25.0
   continue
  }
  int target = 0
  if(demo)
  {
   if(Time() >= nextDemo)
    target = stage + 1
  }
  else
  {
   int limit = GameMode_GetScoreLimit(GameRules_GetGameMode())
   if(limit <= 0)
    continue
   int militia = GameRules_GetTeamScore(TEAM_MILITIA)
   int imc = GameRules_GetTeamScore(TEAM_IMC)
   int best = militia
   if(imc > best)
    best = imc
   int percent = best * 100 / limit
   target = percent >= 75 ? 4 : percent >= 50 ? 3 : percent >= 25 ? 2 : percent >= 5 ? 1 : 0
  }
  if(target > stage)
  {
   stage++
   waitthread TF1Port_mp_tf1_outpost_207_StoryFire(stage)
   nextDemo = Time() + 70.0
  }
 }
}

void function TF1Port_mp_tf1_outpost_207_IntroActorAudio(entity actor,bool militia)
{
 actor.EndSignal("OnDestroy")
 float start = Time()
 if(militia)
 {
  wait max(0.0,start + 0.70000 - Time())
  EmitSoundOnEntity(actor,"outpost207_scr_sarahintro_foley_part1")
  printt("TF1_INTRO_FOLEY","outpost207_scr_sarahintro_foley_part1",Time())
  wait max(0.0,start + 5.06667 - Time())
  EmitSoundOnEntity(actor,"outpost207_scr_sarahintro_foley_part2")
  printt("TF1_INTRO_FOLEY","outpost207_scr_sarahintro_foley_part2",Time())
  wait max(0.0,start + 12.20000 - Time())
  EmitSoundOnEntity(actor,"outpost207_scr_sarahintro_foley_part3")
  printt("TF1_INTRO_FOLEY","outpost207_scr_sarahintro_foley_part3",Time())

 }
 else
 {
  wait max(0.0,start + 2.93333 - Time())
  EmitSoundOnEntity(actor,"outpost207_spyglass_walktohatchandopen")
  printt("TF1_INTRO_FOLEY","outpost207_spyglass_walktohatchandopen",Time())
  wait max(0.0,start + 9.36667 - Time())
  EmitSoundOnEntity(actor,"generic_dropshipleverpull")
  printt("TF1_INTRO_FOLEY","generic_dropshipleverpull",Time())

 }
}

void function TF1Port_mp_tf1_outpost_207_IntroDoorAudio(entity ship)
{
 ship.EndSignal("OnDestroy")
 int attachment = ship.LookupAttachment("RAMPDOORLIP")
 if(attachment <= 0)
 {
  printt("TF1_INTRO_AUDIO_MISSING_RAMP_ATTACHMENT")
  return
 }
 entity emitter = CreateScriptMover(ship.GetAttachmentOrigin(attachment),ship.GetAngles())
 emitter.SetParent(ship,"RAMPDOORLIP")
 OnThreadEnd(
  function() : (emitter)
  {
   if(IsValid(emitter))
    emitter.Destroy()
  }
 )
 string event = "dropship_zipline_door_open"
 float duration = EmitSoundOnEntity(emitter,event)
 if(duration <= 0.0)
 {
  printt("TF1_INTRO_AUDIO_UNAVAILABLE",event)
  return
 }
 printt("TF1_INTRO_DOOR","dropship_zipline_door_open",Time())
 wait duration
}

void function TF1Port_mp_tf1_outpost_207_IntroShipFlyinAudio(entity ship,int team)
{
 if(!true)
  return
 ship.EndSignal("OnDestroy")
 string event = team == TEAM_IMC ? "goblin_imc_classicmp_flyin" : "crow_mcor_classicmp_flyin"
 float duration = EmitSoundOnEntity(ship,event)
 if(duration <= 0.0)
 {
  printt("TF1_INTRO_AUDIO_UNAVAILABLE",event)
  return
 }
 printt("TF1_INTRO_AUDIO_FLYIN",event,Time(),ship.GetOrigin(),duration)
}

void function TF1Port_mp_tf1_outpost_207_IntroShipDepartureAudio(entity ship,int team,float takeoff)
{
 if(!true)
  return
 ship.EndSignal("OnDestroy")
 wait takeoff
 string event = team == TEAM_IMC ? "goblin_imc_classicmp_flyaway" : "crow_mcor_classicmp_flyaway"
 float duration = EmitSoundOnEntity(ship,event)
 if(duration <= 0.0)
 {
  printt("TF1_INTRO_AUDIO_UNAVAILABLE",event)
  return
 }
 printt("TF1_INTRO_AUDIO_FLYAWAY",event,Time(),ship.GetOrigin())
}
const int TF1_INTRO_AI_SPECTRE = 1
const int TF1_INTRO_AI_GRUNT = 2
const int TF1_INTRO_AI_TITAN = 3
const string TF1_INTRO_AI_RIGGINS = "#NPC_LT_RIGGINS"
const string TF1_INTRO_AI_MESSERLY = "#NPC_SGT_MESSERLY"
const float TF1_INTRO_AI_MATCH_GATE_TIMEOUT = 45.0
const float TF1_INTRO_AI_IMC_HANDOFF_WAIT = 5.0
const float TF1_INTRO_AI_IMC_READY_VOICE_WAIT = 3.4

int TF1IntroAI_namedTitansReady = 0
bool TF1IntroAI_matchGateOpen = false
bool TF1IntroAI_matchGateWaiting = false
entity TF1IntroAI_imcTitanReplacement = null
bool TF1IntroAI_imcFallbackVoicePlaying = false
table<entity,float> TF1IntroAI_rampOpenTimes

void function TF1IntroAI_SetNameTag( entity actor, string tag )
{
	if ( !IsValid( actor ) )
	{
		printt( "TF1_INTRO_AI_ERROR", "name_tag_invalid_actor", tag )
		return
	}
	actor.SetScriptName( tag )
	printt( "TF1_INTRO_NAME_TAG", tag, actor.LookupAttachment( "HEADSHOT" ) )
}

void function TF1IntroAI_RampWind( entity ship )
{
	array<asset> effects = [ $"veh_gunship_door_open_lip_01", $"veh_gunship_door_open_01" ]
	array<string> attachments = [ "RAMPDOORLIP", "ORIGIN" ]
	for ( int i = 0; i < effects.len(); i++ )
	{
		int attachment = ship.LookupAttachment( attachments[i] )
		int effect = GetParticleSystemIndex( effects[i] )
		if ( attachment <= 0 || effect <= 0 )
		{
			printt( "TF1_INTRO_RAMP_ERROR", effects[i], attachments[i], effect, attachment )
			continue
		}
		StartParticleEffectOnEntity( ship, effect, FX_PATTACH_POINT_FOLLOW, attachment )
		printt( "TF1_INTRO_RAMP_FX", effects[i], attachments[i], Time() )
	}
}

void function TF1IntroAI_RampBloom( entity player, entity ship, float rampOpen, float jumpAt )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	ship.EndSignal( "OnDestroy" )
	float rampAt = TF1Port_mp_tf1_outpost_207_introStart + rampOpen
	if ( rampAt < Time() || rampAt >= jumpAt )
		return
	wait max( 0.0, rampAt - Time() )
	if ( !IsValid( player ) || !IsValid( ship ) )
		return
	Remote_CallFunction_NonReplay( player, "ServerCallback_TF1IntroRampExposure" )
	printt( "TF1_INTRO_RAMP_BLOOM", player.GetTeam(), Time() )
}

// Prefer the moving replacement; retain the old speaker if the handoff cannot complete.
void function TF1IntroAI_ImcTitanReadyVoice( entity titan )
{
	float deadline = Time() + TF1_INTRO_AI_IMC_HANDOFF_WAIT
	while ( !IsValid( TF1IntroAI_imcTitanReplacement ) && Time() < deadline )
		wait 0.05
	if ( IsValid( TF1IntroAI_imcTitanReplacement ) )
	{
		TF1Port_mp_tf1_outpost_207_IntroImcVO( TF1IntroAI_imcTitanReplacement, "diag_sp_addtional_TR411_61_mcor_og" )
		printt( "TF1_INTRO_AI_READY_VO", "ai", TF1IntroAI_imcTitanReplacement.GetEncodedEHandle(), Time() )
		return
	}
	if ( !IsValid( titan ) )
	{
		printt( "TF1_INTRO_AI_ERROR", "ready_voice_no_speaker" )
		return
	}
	printt( "TF1_INTRO_AI_ERROR", "ready_voice_prop_fallback" )
	TF1IntroAI_imcFallbackVoicePlaying = true
	TF1Port_mp_tf1_outpost_207_IntroImcVO( titan, "diag_sp_addtional_TR411_61_mcor_og" )
	printt( "TF1_INTRO_AI_READY_VO", "prop", titan.GetEncodedEHandle(), Time() )
	// The fallback recording lasts 3.142676 s; keep the prop for a little longer.
	wait TF1_INTRO_AI_IMC_READY_VOICE_WAIT
	TF1IntroAI_imcFallbackVoicePlaying = false
}

// As in TF1, Attrition starts only once both story titans have finished their intro and are active.
bool function TF1IntroAI_MatchGateOpen()
{
	if ( TF1IntroAI_matchGateOpen )
		return true
	if ( !TF1IntroAI_matchGateWaiting )
	{
		TF1IntroAI_matchGateWaiting = true
		thread TF1IntroAI_MatchGateWait()
	}
	return false
}

void function TF1IntroAI_MatchGateWait()
{
	float started = Time()
	printt( "TF1_INTRO_AI_MATCH_GATE", "waiting", TF1IntroAI_namedTitansReady )
	while ( TF1IntroAI_namedTitansReady < 2 && Time() - started < TF1_INTRO_AI_MATCH_GATE_TIMEOUT )
		wait 0.25
	TF1IntroAI_matchGateOpen = true
	printt( "TF1_INTRO_AI_MATCH_GATE", "open", TF1IntroAI_namedTitansReady, Time() - started )
	TF1Port_mp_tf1_outpost_207_TF1Intro_StartPlaying()
}

// The original story radio already supplies the briefing; only show the mode splash here.
void function TF1IntroAI_AnnounceMode()
{
	WaitFrame()
	foreach ( entity player in GetPlayerArray() )
	{
		if ( !IsValid( player ) )
			continue
		Remote_CallFunction_NonReplay( player, "ServerCallback_GameModeAnnouncement" )
		printt( "TF1_INTRO_AI_MODE_ANNOUNCE", player.GetPlayerName(), player.GetTeam(), "splash_only" )
	}
}

array<vector> function TF1IntroAI_ClearSpot( entity ignored, vector center, bool titan, bool includeCenter )
{
	vector ang = ignored.GetAngles()
	vector forward = AnglesToForward( Vector( 0, ang.y, 0 ) )
	vector right = AnglesToRight( Vector( 0, ang.y, 0 ) )
	float step = titan ? 128.0 : 48.0
	vector mins = titan ? Vector( -60, -60, 0 ) : Vector( -16, -16, 0 )
	vector maxs = titan ? Vector( 60, 60, 240 ) : Vector( 16, 16, 72 )
	array<vector> offsets = []
	if ( includeCenter )
		offsets.append( Vector( 0, 0, 0 ) )
	foreach ( float distance in [ step, step * 2.0, step * 3.0 ] )
	{
		offsets.append( forward * distance )
		offsets.append( forward * -distance )
		offsets.append( right * distance )
		offsets.append( right * -distance )
	}
	foreach ( vector offset in offsets )
	{
		vector point = center + offset
		TraceResults floor = TraceLine( point + Vector( 0, 0, 96 ), point - Vector( 0, 0, 256 ), [ ignored ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
		if ( floor.startSolid || floor.fraction >= 1.0 || floor.surfaceNormal.z < 0.65 || fabs( floor.endPos.z - center.z ) > 64.0 )
			continue
		vector foot = floor.endPos + Vector( 0, 0, 4 )
		if ( IsPointOutOfBounds( foot + Vector( 0, 0, 36 ) ) )
			continue
		TraceResults hull = TraceHull( foot, foot + Vector( 0, 0, 0.1 ), mins, maxs, [ ignored ], TRACE_MASK_NPCWORLDSTATIC | TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
		if ( !hull.startSolid && !hull.allSolid )
			return [ foot ]
	}
	return []
}

vector function TF1IntroAI_ActorFoot( entity prop )
{
	vector origin = prop.GetOrigin()
	int left = prop.LookupAttachment( "foot_L_sole" )
	int right = prop.LookupAttachment( "foot_R_sole" )
	if ( left > 0 && right > 0 )
	{
		vector feet = ( prop.GetAttachmentOrigin( left ) + prop.GetAttachmentOrigin( right ) ) * 0.5
		if ( Distance2D( feet, origin ) < 512.0 && fabs( feet.z - origin.z ) < 128.0 )
			return feet
	}
	return origin
}

entity function TF1IntroAI_CreateNPC( int kind, int team, vector origin, vector angles, asset model )
{
	entity npc = null
	if ( kind == TF1_INTRO_AI_SPECTRE )
		npc = CreateSpectre( team, origin, angles )
	else if ( kind == TF1_INTRO_AI_GRUNT )
		npc = CreateSoldier( team, origin, angles )
	else if ( kind == TF1_INTRO_AI_TITAN )
	{
		string settings = ""
		foreach ( string candidate in GetAllowedPlayerTitanSettings() )
		{
			if ( candidate == "titan_atlas_tracker" && ModelIsPrecached( GetPlayerSettingsAssetForClassName( candidate, "bodymodel" ) ) )
			{
				settings = candidate
				break
			}
		}
		if ( settings == "" )
		{
			printt( "TF1_INTRO_AI_ERROR", "titan_settings_unavailable", origin )
			return null
		}
		npc = CreateNPCTitan( settings, team, origin, angles )
		SetSpawnOption_AISettings( npc, "npc_titan_atlas_tracker" )
		SetSpawnOption_Weapon( npc, "mp_titanweapon_40mm" )
	}
	else
	{
		printt( "TF1_INTRO_AI_ERROR", "invalid_kind", kind )
		return null
	}
	if ( kind != TF1_INTRO_AI_TITAN )
		SetSpawnOption_Weapon( npc, "mp_weapon_rspn101" )
	DispatchSpawn( npc )
	if ( !IsValid( npc ) || !IsAlive( npc ) )
	{
		printt( "TF1_INTRO_AI_ERROR", "spawn_failed", kind, origin )
		return null
	}
	if ( kind != TF1_INTRO_AI_TITAN )
		npc.SetModel( model )
	npc.DisableHibernation()
	return npc
}

entity function TF1IntroAI_NearestEnemy( entity npc, int team )
{
	int enemyTeam = team == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
	entity nearest = null
	float bestDistance = 10000000.0
	foreach ( entity player in GetPlayerArray() )
	{
		if ( !IsValid( player ) || !IsAlive( player ) || player.GetTeam() != enemyTeam || player.GetNoTarget() )
			continue
		float distance = Distance2D( npc.GetOrigin(), player.GetOrigin() )
		if ( distance < bestDistance )
		{
			nearest = player
			bestDistance = distance
		}
	}
	foreach ( entity candidate in GetNPCArray() )
	{
		if ( !IsValid( candidate ) || !IsAlive( candidate ) || candidate.GetTeam() != enemyTeam || candidate.GetNoTarget() )
			continue
		float distance = Distance2D( npc.GetOrigin(), candidate.GetOrigin() )
		if ( distance < bestDistance )
		{
			nearest = candidate
			bestDistance = distance
		}
	}
	return nearest
}

void function TF1IntroAI_Direct( entity npc, int kind, int team, string label )
{
	npc.EndSignal( "OnDestroy" )
	npc.EndSignal( "OnDeath" )
	npc.DisableNPCFlag( NPC_IGNORE_ALL | NPC_DISABLE_SENSING )
	npc.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_ALLOW_FLEE | NPC_ALLOW_HAND_SIGNALS )
	npc.EnableBehavior( "Assault" )
	npc.AssaultSetArrivalTolerance( 24 )
	npc.AssaultSetGoalRadius( kind == TF1_INTRO_AI_TITAN ? 192 : 48 )
	vector start = npc.GetOrigin()
	vector patrolGoal = start
	bool hasPatrolGoal = false
	bool warnedNoGoal = false
	int sample = 0
	while ( IsValid( npc ) && IsAlive( npc ) )
	{
		entity enemy = TF1IntroAI_NearestEnemy( npc, team )
		if ( IsValid( enemy ) )
		{
			npc.AssaultPoint( enemy.GetOrigin() )
			hasPatrolGoal = false
		}
		else
		{
			if ( !hasPatrolGoal || Distance2D( npc.GetOrigin(), patrolGoal ) < 48.0 )
			{
				array<vector> goals = TF1IntroAI_ClearSpot( npc, npc.GetOrigin(), kind == TF1_INTRO_AI_TITAN, false )
				if ( goals.len() > 0 )
				{
					patrolGoal = goals[0]
					hasPatrolGoal = true
				}
				else if ( !warnedNoGoal )
				{
					printt( "TF1_INTRO_AI_ERROR", "no_patrol_goal", label, npc.GetOrigin() )
					warnedNoGoal = true
				}
			}
			if ( hasPatrolGoal )
				npc.AssaultPoint( patrolGoal )
		}
		if ( sample < 12 )
		{
			entity weapon = npc.GetActiveWeapon()
			printt( "TF1_INTRO_AI_SAMPLE", label, npc.GetEncodedEHandle(), sample, "origin", npc.GetOrigin(), "displacement", Distance2D( start, npc.GetOrigin() ), "weapon", IsValid( weapon ), "enemy", IsValid( enemy ) )
		}
		sample++
		wait 5.0
	}
}

void function TF1IntroAI_AnimationWatchdog( entity prop, string label )
{
	prop.EndSignal( "OnDestroy" )
	wait 65.0
	if ( IsValid( prop ) )
		printt( "TF1_INTRO_AI_ERROR", "animation_handoff_timeout", label, prop.GetOrigin() )
}

void function TF1IntroAI_RemoveMarvinAtMatch( entity marvin, entity batonR, entity batonL )
{
	WaittillGameStateOrHigher( eGameState.Playing )
	if ( IsValid( batonR ) )
		batonR.Destroy()
	if ( IsValid( batonL ) )
		batonL.Destroy()
	if ( IsValid( marvin ) )
	{
		printt( "TF1_INTRO_MARVIN_REMOVED", marvin.GetOrigin() )
		marvin.Destroy()
	}
}

void function TF1IntroAI_AfterAnimation( entity prop, int kind, int team, string label, float minDelay )
{
	if ( !IsValid( prop ) )
		return
	prop.EndSignal( "OnDestroy" )
	float started = Time()
	thread TF1IntroAI_AnimationWatchdog( prop, label )
	prop.WaitSignal( "OnAnimationDone" )
	float remaining = minDelay - ( Time() - started )
	if ( remaining > 0.0 )
		wait remaining
	if ( label == "imc_titan" )
		while ( TF1IntroAI_imcFallbackVoicePlaying )
			wait 0.05
	if ( !IsValid( prop ) )
		return
	vector foot = TF1IntroAI_ActorFoot( prop )
	array<vector> spots = TF1IntroAI_ClearSpot( prop, foot, kind == TF1_INTRO_AI_TITAN, true )
	if ( spots.len() == 0 )
	{
		printt( "TF1_INTRO_AI_ERROR", "no_spawn_clearance", label, foot )
		return
	}
	asset model = prop.GetModelName()
	entity npc = TF1IntroAI_CreateNPC( kind, team, spots[0], prop.GetAngles(), model )
	if ( !IsValid( npc ) || !IsAlive( npc ) )
	{
		printt( "TF1_INTRO_AI_ERROR", "replacement_failed", label, foot )
		return
	}
	if ( npc.GetTeam() != team || ( kind != TF1_INTRO_AI_TITAN && npc.GetModelName() != model ) )
	{
		printt( "TF1_INTRO_AI_ERROR", "replacement_mismatch", label, npc.GetTeam(), npc.GetModelName() )
		npc.Destroy()
		return
	}
	string nameTag = prop.GetScriptName()
	if ( nameTag != "" )
		TF1IntroAI_SetNameTag( npc, nameTag )
	if ( kind == TF1_INTRO_AI_TITAN )
	{
		string title = ""
		if ( team == TEAM_MILITIA && label == "militia_titan" )
			title = TF1_INTRO_AI_RIGGINS
		else if ( team == TEAM_IMC && label == "imc_titan" )
			title = TF1_INTRO_AI_MESSERLY
		if ( title != "" )
		{
			npc.SetTitle( title )
			ShowName( npc )
			if ( label == "imc_titan" )
				TF1IntroAI_imcTitanReplacement = npc
			TF1IntroAI_namedTitansReady++
		}
		printt( "TF1_INTRO_AI_TITLE", label, npc.GetEncodedEHandle(), npc.GetTitle() )
	}
	printt( "TF1_INTRO_AI_SPAWNED", label, npc.GetEncodedEHandle(), npc.GetClassName(), npc.GetTeam(), npc.GetOrigin(), npc.GetModelName() )
	thread TF1IntroAI_Direct( npc, kind, team, label )
	prop.Destroy()
}
