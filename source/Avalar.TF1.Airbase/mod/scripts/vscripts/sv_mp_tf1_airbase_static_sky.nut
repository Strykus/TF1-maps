global function TF1AirbaseStaticSky_ServerPrecache

void function TF1AirbaseStaticSky_ServerPrecache()
{
 if ( GetMapName() != "mp_tf1_airbase" )
  return
  PrecacheModel( $"models/tf1_airbase/sky_carrier.mdl" )
  PrecacheModel( $"models/imc_base/worker_base_whistle_tower_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_a_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_b_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_c_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_d_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_e_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_f_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_g_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_h_skybox.mdl" )
  PrecacheModel( $"models/imc_base/radar_i_skybox.mdl" )
}
