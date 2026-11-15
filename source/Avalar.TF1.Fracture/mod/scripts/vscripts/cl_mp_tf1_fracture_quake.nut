global function TF1FractureQuake_Shutdown
global function TF1FractureQuake_Precache
global function ServerCallback_TF1FractureCrackEffects
global function ServerCallback_TF1FracturePlateStrike

struct
{
 entity plate
 array<int> dust
 array<var> sounds
} file

void function TF1FractureQuake_Shutdown()
{
 if ( IsValid( file.plate ) )
  file.plate.Destroy()
 file.plate = null
 foreach ( effect in file.dust )
  if ( EffectDoesExist( effect ) )
   EffectStop( effect, true, false )
 foreach ( sound in file.sounds )
  StopSound( sound )
 file.dust.clear()
 file.sounds.clear()
}

void function TF1FractureQuake_Precache()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 PrecacheModel( $"models/vistas/fracture_se_land_plate_anim.mdl" )
 PrecacheParticleSystem( $"mp_tf1_fracture_quake_env_megathumper_dust_crack" )
}

void function ServerCallback_TF1FracturePlateStrike()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 TF1FractureSky_Start()
 thread TF1FractureQuake_MovePlate()
}

void function TF1FractureQuake_MovePlate()
{
 if ( IsValid( file.plate ) )
  return
 entity plate = CreateClientSidePropDynamic( Vector(-12288, -12288, -9728), Vector(0, 90, 0), $"models/vistas/fracture_se_land_plate_anim.mdl" )
 file.plate = plate
 plate.EndSignal( "OnDestroy" )
 plate.Anim_Play( "strike" )
 printt( "TF1_FRACTURE_CLIENT_PLATE_STRIKE" )
 wait plate.GetSequenceDuration( "strike" )
 plate.Anim_Play( "post_strike" )
}

void function ServerCallback_TF1FractureCrackEffects()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 int fx = GetParticleSystemIndex( $"mp_tf1_fracture_quake_env_megathumper_dust_crack" )
 array<vector> positions = [
  Vector(-2093.01, -5000.19, 145.897),
  Vector(-3186.28, -1606.7, 226.729),
  Vector(-2843.52, -1388, 273.527),
  Vector(-672.27, 131.38, 119.09),
  Vector(-426.912, -976.807, 355.376),
  Vector(1054.78, -285.025, 189.961),
  Vector(-2136.68, -1439.95, 155.685),
  Vector(-161.649, -202.607, 230.167),
  Vector(-3040.7, -1490.73, 246.564),
  Vector(-3320.47, -4767.83, 107.025),
  Vector(-2083.65, -4793.58, 145.897),
  Vector(-2127.51, -5202.55, 138.193),
  Vector(2423.03, -2806, 367.954),
  Vector(180.375, -5017.75, 201.668),
  Vector(4997.07, -2038.9, -128.766),
  Vector(4346.57, -2959.38, -78.1964),
  Vector(4979.82, 4803.03, -187.521),
  Vector(5030.86, -668.113, -207.677),
  Vector(5381.37, 944.124, -177.598)
 ]
 array<vector> angles = [
  Vector(0.527094, 87.0979, -6.83166),
  Vector(14.5599, -143.93, -9.11236e-016),
  Vector(-15.4251, -134.718, 9.68016e-016),
  Vector(-3.78006, -115.401, -15.0781),
  Vector(-6.54549e-016, 122.489, -10.7526),
  Vector(-12.9362, -73.334, -17.8676),
  Vector(-8.13226, -36.465, -16.5687),
  Vector(-6.56005e-016, 7.7105, -10.7768),
  Vector(-0, -158.377, 0),
  Vector(0.527094, 87.0979, 24.1406),
  Vector(12.0839, 85.6914, -6.98693),
  Vector(-16.9894, 84.8109, -7.16613),
  Vector(-6.90018e-016, -30.243, -11.3428),
  Vector(-0, 0.9949, 0),
  Vector(-1.72474e-015, 62.3831, -29.4464),
  Vector(6.0115, 56.3214, -17.8886),
  Vector(9.32592e-016, 31.392, 15.4157),
  Vector(-2.10791e-015, 175.312, -36.9291),
  Vector(-1.60772e-015, -12.279, -27.2745)
 ]
 foreach ( int i, vector origin in positions )
 {
  file.dust.append( StartParticleEffectInWorldWithHandle( fx, origin, angles[i] ) )
  file.sounds.append( EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "Fracture_RockShower" ) )
 }
 printt( "TF1_FRACTURE_CLIENT_CRACK_EFFECTS", positions.len() )
}




