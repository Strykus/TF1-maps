global function TF1AirbaseForklift_ServerPrecache

void function TF1AirbaseForklift_ServerPrecache()
{
    if ( GetMapName() == "mp_tf1_airbase" )
        PrecacheModel( $"models/tf1_mapcache/mp_tf1_airbase/c3e8800dcc9b2fa7e5bc.mdl" )
}
