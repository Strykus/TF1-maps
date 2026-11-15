global function TF1FractureSky_Start
global function TF1FractureSky_Precache
global function TF1FractureSky_Init
global function TF1FractureSky_Shutdown

const asset REDEYE = $"models/tf1_fractr/atmosphere/redeye.mdl"
const asset BIRMINGHAM = $"models/tf1_fractr/atmosphere/birmingham.mdl"
const asset REDEYE_WARP_IN = $"mp_tf1_fracture_sky_veh_red_warp_in_full_SB"
const asset REDEYE_WARP_OUT = $"mp_tf1_fracture_sky_veh_red_warp_out_full_SB"
const asset BIRMINGHAM_WARP_IN = $"mp_tf1_fracture_sky_veh_birm_warp_in_full_SB"
const asset BIRMINGHAM_WARP_OUT = $"mp_tf1_fracture_sky_veh_birm_warp_out_full_SB"
const asset SHIP_EXPLOSION = $"mp_tf1_fracture_sky_P_exp_refuelship_SBox"
const asset TRACER = $"mp_tf1_fracture_sky_P_tracers_loop_SBox"

struct
{
 bool started
 bool active
 vector center = < -12285, -12291, -9701>
 vector direction = < -0.813501, 0.580235, -0.039295>
 array<entity> ships
 array<int> tracers
 array<vector> refuel = [
  < -12218.9, -12399.3, -9722.37>,
  < -12257.2, -12478.8, -9718.71>,
  < -12415.7, -12350.9, -9706.98>,
  < -12334.1, -12442.2, -9686.28>,
  < -12269.5, -12142.4, -9696.13>,
  < -12179.4, -12146, -9692.02>,
  < -12296.5, -12375.4, -9714.79>,
  < -12444.3, -12403, -9699.96>,
  < -12181.8, -11915.7, -9674.69>,
  < -12078.8, -12341.7, -9728.42>
 ]
 array<vector> batteries = [
  < -12330.8, -12322.1, -9723.24>,
  < -12365.1, -12311, -9716.63>,
  < -12430.9, -12288.4, -9707.88>,
  < -12314.2, -12335.8, -9714.8>,
  < -12214.6, -12464.3, -9716.04>,
  < -12132.6, -12440.2, -9722.67>,
  < -12171.2, -12298.6, -9727.18>,
  < -12113.2, -12308.6, -9726.92>,
  < -12188.3, -12240, -9715.56>,
  < -12206.3, -12163.5, -9694.23>,
  < -12275.9, -12228.1, -9718.16>,
  < -12305.8, -12244.8, -9722.69>,
  < -12331.5, -12244.4, -9717.4>,
  < -12250.8, -12253.1, -9718.1>,
  < -12241.8, -12193.2, -9705.73>,
  < -12304.4, -12179, -9713.75>,
  < -12285.8, -12139.1, -9699.72>,
  < -12189.3, -12214.6, -9711.79>,
  < -12393.7, -12399.6, -9695.95>,
  < -12157.2, -12334.9, -9729.29>
 ]
} file

void function TF1FractureSky_Precache()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 PrecacheModel( REDEYE )
 PrecacheModel( BIRMINGHAM )
 PrecacheParticleSystem( REDEYE_WARP_IN )
 PrecacheParticleSystem( REDEYE_WARP_OUT )
 PrecacheParticleSystem( BIRMINGHAM_WARP_IN )
 PrecacheParticleSystem( BIRMINGHAM_WARP_OUT )
 PrecacheParticleSystem( SHIP_EXPLOSION )
 PrecacheParticleSystem( TRACER )
}

void function TF1FractureSky_Init()
{
 if ( GetMapName() != "mp_tf1_fracture" || file.active )
  return
 file.active = true
 thread TF1FractureSky_Run()
}

void function TF1FractureSky_Shutdown()
{
 file.active = false
 foreach ( ship in file.ships )
  if ( IsValid( ship ) )
   ship.Destroy()
 foreach ( effect in file.tracers )
  if ( EffectDoesExist( effect ) )
   EffectStop( effect, true, false )
 file.ships.clear()
 file.tracers.clear()
}

bool function TF1FractureSky_InMatch()
{
 return file.active && GetGameState() <= eGameState.SuddenDeath
}

void function TF1FractureSky_Run()
{
 while ( file.active && GetGameState() < eGameState.Playing )
  wait 0.05
 TF1FractureSky_Start()
}

void function TF1FractureSky_Start()
{
 if ( file.started || !TF1FractureSky_InMatch() )
  return
 file.started = true
 thread TF1FractureSky_StartEffects()
}

void function TF1FractureSky_StartEffects()
{
 thread TF1FractureSky_Flybys()
 wait 1.0
 foreach ( point in file.refuel )
  thread TF1FractureSky_Refuel( point )
 wait 7.0
 foreach ( point in file.batteries )
  thread TF1FractureSky_Battery( point )
 printt( "TF1_FRACTURE_SKYBOX_STARTED" )
}

entity function TF1FractureSky_Create( asset model, vector origin, vector angles )
{
 entity ship = CreateClientsideScriptMover( model, origin, angles )
 file.ships.append( ship )
 ship.Hide()
 asset warp = model == REDEYE ? REDEYE_WARP_IN : BIRMINGHAM_WARP_IN
 StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( warp ), origin, angles )
 return ship
}

void function TF1FractureSky_Remove( entity ship, asset model, bool warp )
{
 if ( !IsValid( ship ) )
  return
 if ( warp )
 {
  asset effect = model == REDEYE ? REDEYE_WARP_OUT : BIRMINGHAM_WARP_OUT
  StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( effect ), ship.GetOrigin(), ship.GetAngles() )
 }
 file.ships.removebyvalue( ship )
 ship.Destroy()
}

void function TF1FractureSky_Flybys()
{
 vector angles = VectorToAngles( file.direction )
 vector right = AnglesToRight( angles )
 array<int> lanes = [1, 6, 4, 0, 5, 3, 7, 2]
 array<asset> models = [BIRMINGHAM, BIRMINGHAM, BIRMINGHAM, REDEYE, REDEYE, REDEYE, REDEYE, REDEYE]
 while ( TF1FractureSky_InMatch() )
 {
  for ( int index = 0; index < lanes.len(); index++ )
  {
   if ( !TF1FractureSky_InMatch() )
    return
   float forwardOffset = -800.0 + RandomFloatRange( 0.0, 500.0 )
   vector start = file.center + file.direction * forwardOffset
   float jitter = RandomFloatRange( 0.0, 70.0 ) - 35.0
   start += right * ( -306.25 + 87.5 * lanes[index] + jitter )
   float height = RandomFloatRange( 100.0, 200.0 )
   start += <0, 0, 1> * height
   thread TF1FractureSky_Fly( models[index], start, angles )
   wait 0.35
  }
  wait 25.0
  for ( int i = lanes.len() - 1; i > 0; i-- )
  {
   int j = RandomInt( i + 1 )
   int lane = lanes[j]
   lanes[j] = lanes[i]
   lanes[i] = lane
   j = RandomInt( i + 1 )
   asset model = models[j]
   models[j] = models[i]
   models[i] = model
  }
 }
}

void function TF1FractureSky_Fly( asset model, vector start, vector angles )
{
 entity ship = TF1FractureSky_Create( model, start, angles )
 ship.EndSignal( "OnDestroy" )
 float duration = RandomFloatRange( 100.0, 200.0 )
 ship.NonPhysicsMoveTo( start + file.direction * 1600.0, duration, 0.0, 0.0 )
 wait 0.25
 ship.Show()
 for ( float elapsed = 0.25; elapsed < duration && TF1FractureSky_InMatch(); elapsed += 0.5 )
  wait 0.5
 if ( file.active && !TF1FractureSky_InMatch() )
  wait RandomFloatRange( 0.0, 30.0 )
 TF1FractureSky_Remove( ship, model, true )
}

void function TF1FractureSky_Refuel( vector point )
{
 wait RandomFloatRange( 0.0, 4.0 )
 while ( TF1FractureSky_InMatch() )
 {
  float hover = RandomFloatRange( 10.0, 20.0 )
  thread TF1FractureSky_RefuelShip( point, hover )
  wait hover + RandomFloatRange( 10.0, 30.0 )
 }
}

void function TF1FractureSky_RefuelShip( vector point, float hover )
{
 vector angles = VectorToAngles( file.direction )
 entity ship = TF1FractureSky_Create( REDEYE, point - file.direction * 800.0 + <0, 0, 70>, angles )
 ship.EndSignal( "OnDestroy" )
 ship.NonPhysicsMoveTo( point + <0, 0, 25>, 30.0, 0.0, 15.0 )
 wait 0.25
 ship.Show()
 wait 29.75
 if ( TF1FractureSky_InMatch() && RandomInt( 3 ) == 0 )
 {
  vector away = Normalize( ship.GetOrigin() - file.center )
  float direction = RandomInt( 2 ) == 0 ? -1.0 : 1.0
  ship.NonPhysicsMoveTo( ship.GetOrigin() + away * 50.0 + file.direction * ( direction * 30.0 ) + <0, 0, -30>, 10.0, 9.0, 0.0 )
  float pitch = RandomFloatRange( 60.0, 85.0 )
  ship.NonPhysicsRotateTo( <direction * pitch, angles.y, 0>, 10.0, 9.0, 0.0 )
  int effect = StartParticleEffectOnEntity( ship, GetParticleSystemIndex( SHIP_EXPLOSION ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
  wait 10.0
  if ( EffectDoesExist( effect ) )
   EffectStop( effect, false, true )
  wait 0.01
  TF1FractureSky_Remove( ship, REDEYE, false )
  return
 }
 wait hover
 ship.NonPhysicsMoveTo( point + file.direction * 800.0 + <0, 0, 50>, 30.0, 15.0, 0.0 )
 wait 30.0
 TF1FractureSky_Remove( ship, REDEYE, true )
}

void function TF1FractureSky_Battery( vector point )
{
 if ( !TF1FractureSky_InMatch() )
  return
 int effect = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( TRACER ), point, <0, 0, 1> )
 file.tracers.append( effect )
 vector base = point + <0, 0, 75>
 vector aim = base
 while ( TF1FractureSky_InMatch() && EffectDoesExist( effect ) )
 {
  float stop = Time() + RandomFloatRange( 3.0, 8.0 )
  EffectWake( effect )
  while ( Time() < stop && TF1FractureSky_InMatch() && EffectDoesExist( effect ) )
  {
   float yaw = RandomFloatRange( 0.0, 360.0 )
   float radius = RandomFloatRange( 0.0, 75.0 )
   vector nextAim = base + AnglesToForward( <0, yaw, 0> ) * radius
   float duration = max( 0.10, Distance( aim, nextAim ) / 50.0 )
   for ( float elapsed = 0.0; elapsed < duration && Time() < stop && TF1FractureSky_InMatch() && EffectDoesExist( effect ); elapsed += 0.10 )
   {
    EffectSetControlPointVector( effect, 1, aim + (nextAim - aim) * (elapsed / duration) )
    wait 0.10
   }
   aim = nextAim
  }
  if ( EffectDoesExist( effect ) )
   EffectSleep( effect )
  wait RandomFloatRange( 1.0, 4.0 )
 }
 if ( EffectDoesExist( effect ) )
  EffectStop( effect, false, false )
 file.tracers.removebyvalue( effect )
}
