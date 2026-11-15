global function TF1ExportElectric_Precache
global function TF1ExportElectric_Init

struct TrapEvent
{
 float time
 int zone
 float duration
}
struct
{
 array<entity> zones
 array<float> expires
 array<TrapEvent> events
 entity glow
 entity panel
 float readyAt = 0.0
 entity attacker
 bool active = false
} file

void function TF1ExportElectric_Precache()
{
 if (GetMapName() != "mp_tf1_switchback") return
 PrecacheParticleSystem($"mp_tf1_switchback_P_Swtch_Elec_Pole")
 PrecacheParticleSystem($"mp_tf1_switchback_P_Swtch_Elec_Ring_P")
 PrecacheParticleSystem($"mp_tf1_switchback_P_Swtch_Elec_Hazard_HLD")
 PrecacheParticleSystem($"mp_tf1_switchback_P_Swtch_Elec_Wall_HLD")
 PrecacheParticleSystem($"mp_tf1_switchback_P_Swtch_Gen_Exp")
}

void function TF1ExportElectric_Init()
{
 if (GetMapName() != "mp_tf1_switchback") return
 AddCallback_EntitiesDidLoad(TF1ExportElectric_Setup)
}

void function TF1ExportElectric_AddEvent(float at, int zone, float duration)
{
 TrapEvent e
 e.time = at
 e.zone = zone
 e.duration = duration
 file.events.append(e)
}

void function TF1ExportElectric_Setup()
{
 file.panel = GetEnt("prop_aoe_electrical_panel_1")
 file.glow = GetEnt("prop_ar_glow")
 if (!IsValid(file.panel) || !IsValid(file.glow))
 {
  printt("TF1_EXPORT_ELECTRIC_ERROR missing panel or glow")
  return
 }
 for (int i = 1; i <= 13; i++)
 {
  string name = i == 13 ? "trigger_aoe_smoke_damage_1" : "trigger_aoe_elec_damage_" + i
  entity zone = GetEnt(name)
  if (!IsValid(zone))
  {
   printt("TF1_EXPORT_ELECTRIC_ERROR missing trigger", name)
   return
  }
  file.zones.append(zone)
  file.expires.append(-1.0)
 }
 TF1ExportElectric_AddEvent(0.25000, 0, 2.00000)
 TF1ExportElectric_AddEvent(0.40000, 1, 2.00000)
 TF1ExportElectric_AddEvent(0.55000, 2, 2.00000)
 TF1ExportElectric_AddEvent(0.70000, 3, 2.00000)
 TF1ExportElectric_AddEvent(0.85000, 4, 2.00000)
 TF1ExportElectric_AddEvent(1.00000, 5, 2.00000)
 TF1ExportElectric_AddEvent(1.15000, 6, 2.00000)
 TF1ExportElectric_AddEvent(1.30000, 7, 2.00000)
 TF1ExportElectric_AddEvent(1.45000, 8, 2.00000)
 TF1ExportElectric_AddEvent(1.60000, 9, 2.00000)
 TF1ExportElectric_AddEvent(1.75000, 10, 2.00000)
 TF1ExportElectric_AddEvent(1.90000, 11, 2.00000)
 TF1ExportElectric_AddEvent(2.05000, 12, 9.50000)
 TF1ExportElectric_AddEvent(2.80000, 0, 2.00000)
 TF1ExportElectric_AddEvent(3.15000, 3, 2.00000)
 TF1ExportElectric_AddEvent(3.55000, 0, 2.00000)
 TF1ExportElectric_AddEvent(3.80000, 2, 2.00000)
 TF1ExportElectric_AddEvent(4.15000, 5, 2.00000)
 TF1ExportElectric_AddEvent(4.50000, 8, 2.00000)
 TF1ExportElectric_AddEvent(4.75000, 0, 2.00000)
 TF1ExportElectric_AddEvent(5.05000, 4, 2.00000)
 TF1ExportElectric_AddEvent(5.35000, 0, 2.00000)
 TF1ExportElectric_AddEvent(5.70000, 3, 2.00000)
 TF1ExportElectric_AddEvent(5.95000, 5, 2.00000)
 TF1ExportElectric_AddEvent(6.20000, 7, 2.00000)
 TF1ExportElectric_AddEvent(6.55000, 10, 2.00000)
 TF1ExportElectric_AddEvent(7.15000, 0, 2.00000)
 TF1ExportElectric_AddEvent(7.50000, 3, 2.00000)
 TF1ExportElectric_AddEvent(7.75000, 5, 2.00000)
 TF1ExportElectric_AddEvent(8.15000, 0, 2.00000)
 TF1ExportElectric_AddEvent(8.40000, 2, 2.00000)
 TF1ExportElectric_AddEvent(8.65000, 4, 2.00000)
 TF1ExportElectric_AddEvent(9.00000, 7, 2.00000)
 TF1ExportElectric_AddEvent(9.35000, 10, 2.00000)
 TF1ExportElectric_AddEvent(9.85000, 0, 2.00000)
 TF1ExportElectric_AddEvent(10.20000, 3, 2.00000)
 TF1ExportElectric_AddEvent(10.45000, 5, 2.00000)
 TF1ExportElectric_AddEvent(10.80000, 8, 2.00000)
 TF1ExportElectric_AddEvent(11.05000, 10, 2.00000)
 TF1ExportElectric_AddEvent(11.45000, 0, 2.00000)
 TF1ExportElectric_AddEvent(11.80000, 3, 2.00000)
 file.panel.SetTakeDamageType(DAMAGE_EVENTS_ONLY)
 file.panel.SetDamageNotifications(true)
 file.panel.DisableHibernation()
 AddEntityCallback_OnDamaged(file.panel, TF1ExportElectric_PanelHit)
 file.glow.SetTakeDamageType(DAMAGE_EVENTS_ONLY)
 file.glow.SetDamageNotifications(true)
 AddEntityCallback_OnDamaged(file.glow, TF1ExportElectric_PanelHit)
 printt("TF1_EXPORT_ELECTRIC_READY", file.zones.len())
}

void function TF1ExportElectric_PanelHit(entity panel, var info)
{
 entity attacker = DamageInfo_GetAttacker(info)
 if (!IsValid(attacker) || !attacker.IsPlayer() || !IsAlive(attacker)) return
 if (DamageInfo_GetDamage(info) <= 0 || file.active || Time() < file.readyAt) return
 file.active = true
 file.attacker = attacker
 file.readyAt = Time() + 16.0
 file.glow.Hide()
 EmitSoundAtPosition(TEAM_UNASSIGNED, Vector(-47,-656,616), "Switchback_Terminal_Activate")
 printt("TF1_EXPORT_ELECTRIC_ACTIVATED", attacker.GetEntIndex())
 thread TF1ExportElectric_RunTrap()
}

void function TF1ExportElectric_FX(asset name, vector pos, vector angles, float lifetime)
{
 entity fx = CreateEntity("info_particle_system")
 fx.SetValueForEffectNameKey(name)
 fx.kv.start_active = 1
 fx.SetOrigin(pos)
 fx.SetAngles(angles)
 DispatchSpawn(fx)
 thread TF1ExportElectric_StopFX(fx, lifetime)
}

void function TF1ExportElectric_StopFX(entity fx, float lifetime)
{
 wait lifetime
 if (IsValid(fx)) fx.Destroy()
}

void function TF1ExportElectric_RunTrap()
{
 float start = Time()
 int next = 0
 bool smoke = false
 bool explosion = false
 float nextAlarm = 0.0
 float nextSmallArc = RandomFloatRange(0.0, 0.1)
 int smallArcs = 0
 float nextHazardSound = 2.2
 array<vector> sparks = [Vector(-47.0,-654.0,555.0),Vector(-83.0,-656.0,792.0),Vector(-83.0,-656.0,925.0)]
 array<vector> arcs = [Vector(-48.0,-654.0,1212.0),Vector(-46.875,-603.61,1221.79),Vector(-47.0,-369.86,1270.36),Vector(-46.75,224.89,1394.34),Vector(-46.875,458.64,1442.91),Vector(-46.75,702.89,1493.64),Vector(-46.875,1090.15,1574.09),Vector(-46.875,1414.66,1641.5),Vector(-46.875,1937.17,1750.5),Vector(-46.875,2293.99,1824.63),Vector(-46.875,2624.59,1893.3),Vector(-46.875,3000.47,1971.38)]
 array<vector> hazards = [Vector(-43.393,3122.45,1642.74),Vector(-222.393,3122.58,1491.49),Vector(292.467,3192.31,1491.51),Vector(-709.134,3167.91,1438.67),Vector(755.045,3344.52,1491.76)]
 foreach (vector p in sparks) TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Pole", p, <0,0,0>, 11.3)
 while (Time() < start + 16.0)
 {
  float elapsed = Time() - start
  if (elapsed >= nextAlarm && nextAlarm < 14.3)
  {
   EmitSoundAtPosition(TEAM_UNASSIGNED, Vector(-49.75,3352.17,1856.85), "Switchback_Electrical_Alarm")
   nextAlarm += 2.0
  }
  if (smallArcs < 17 && elapsed >= nextSmallArc)
  {
   EmitSoundAtPosition(TEAM_UNASSIGNED, sparks[0], "Switchback_Terminal_Small_Arcs")
   smallArcs++
   nextSmallArc = 0.7 * smallArcs + RandomFloatRange(0.0, 0.1)
  }
  if (elapsed >= nextHazardSound && nextHazardSound < 11.3)
  {
   EmitSoundAtPosition(TEAM_UNASSIGNED, hazards[RandomInt(hazards.len())], "Switchback_Electrical_DamageArea")
   nextHazardSound += 0.5
  }
  while (next < file.events.len() && elapsed >= file.events[next].time)
  {
   TrapEvent e = file.events[next]
   file.expires[e.zone] = max(file.expires[e.zone], Time() + e.duration)
   if (e.zone < 12)
   {
    TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Ring_P", arcs[e.zone], <0,0,0>, 2.0)
    EmitSoundAtPosition(TEAM_UNASSIGNED, arcs[e.zone], "Switchback_Killer_Electrical_Arc")
   }
   next++
  }
  if (!explosion && elapsed >= 2.0)
  {
   explosion = true
   TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Gen_Exp", Vector(-41,3365,2113), <0,0,0>, 2.0)
   EmitSoundAtPosition(TEAM_UNASSIGNED, Vector(-41,3365,2113), "Switchback_building_explosion")
  }
  if (!smoke && elapsed >= 2.2)
  {
   smoke = true
   foreach (vector p in hazards) TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Hazard_HLD", p, <0,0,0>, 9.3)
   TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Wall_HLD", <71.085,2910.91,1505.63>, <0,90,0>, 9.3)
   TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Wall_HLD", Vector(-391.04,2920.28,1505.63), <0,90,0>, 9.3)
   TF1ExportElectric_FX($"mp_tf1_switchback_P_Swtch_Elec_Wall_HLD", <508.738,3034.82,1505.63>, <0,114.5263,0>, 9.3)
  }
  array<entity> victims
  array<bool> instant
  for (int i = 0; i < file.zones.len(); i++)
  {
   if (Time() >= file.expires[i]) continue
   foreach (entity victim in file.zones[i].GetTouchingEntities())
   {
    if (!IsValid(victim) || !IsAlive(victim) || (!victim.IsPlayer() && !victim.IsNPC())) continue
    if (!file.zones[i].IsTouching(victim)) continue
    int index = victims.find(victim)
    if (index < 0)
    {
     victims.append(victim)
     instant.append(i < 12)
    }
    else if (i < 12) instant[index] = true
   }
  }
  foreach (int i, entity victim in victims)
  {
   if (!IsValid(victim) || !IsAlive(victim)) continue
   entity owner = IsValid(file.attacker) ? file.attacker : GetEntByIndex(0)
   entity credited = owner
   if (owner != victim && owner.GetTeam() == victim.GetTeam()) credited = GetEntByIndex(0)
   float damage = victim.IsTitan() || instant[i] ? 200.0 : 15.0
   victim.TakeDamage(damage, credited, owner, {scriptType = DF_INSTANT | DF_ELECTRICAL | DF_GIB, damageSourceId = eDamageSourceId.switchback_trap})
  }
  wait 0.1
 }
 if (IsValid(file.glow)) file.glow.Show()
 file.active = false
 printt("TF1_EXPORT_ELECTRIC_READY_AGAIN")
}
