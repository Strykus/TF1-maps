global function TF1FractureSky_ServerPrecache
void function TF1FractureSky_ServerPrecache()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 PrecacheModel( $"models/tf1_fractr/atmosphere/birmingham.mdl" )
 PrecacheModel( $"models/tf1_fractr/atmosphere/redeye.mdl" )
 PrecacheModel( $"models/tf1_mapcache/mp_tf1_fracture/9b53b2daa06b3e5f4a37.mdl" )
}
