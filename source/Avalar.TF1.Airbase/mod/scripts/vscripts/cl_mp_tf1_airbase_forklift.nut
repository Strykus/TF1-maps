global function TF1AirbaseForklift_Precache
global function TF1AirbaseForklift_Init
global function TF1AirbaseForklift_Shutdown

const asset AIRBASE_FORKLIFT = $"models/tf1_mapcache/mp_tf1_airbase/c3e8800dcc9b2fa7e5bc.mdl"

struct
{
    array<entity> forklifts
} file

void function TF1AirbaseForklift_Precache()
{
    if ( GetMapName() == "mp_tf1_airbase" )
        PrecacheModel( AIRBASE_FORKLIFT )
}

void function TF1AirbaseForklift_Init()
{
    if ( GetMapName() != "mp_tf1_airbase" || file.forklifts.len() != 0 )
        return

    // BSP static props retain collision and shadows. These movers supply their visible models.
    array<vector> origins = [
        < -764, -648, 168.466003418 >,
        < -1920, -2144, 95.998596191 >,
        < -3372, 248, 96 >,
        < -450.570007324, 134.660003662, 575 >,
        < -2539, -3678, 96 >,
        < -3744, -4464, 95.998596191 >,
        < 2096.080078125, -3071.550048828, 359.99899292 >,
        < -481.17401123, 461.052001953, -0.00130919 >,
        < -4613.419921875, 117.163002014, 82.327697754 >,
        < -4845.419921875, 101.163002014, 82.327697754 >,
        < -1804.550048828, 4919.700195312, 95.993301392 >,
        < 1898.729980469, 2716.320068359, 0.801765978 >,
        < -1388.790039062, 821.83001709, 95.997001648 >
    ]
    array<vector> angles = [
        < -0.000098819, -23.395000458, 0.000004134 >,
        < 0.000008712, -86.675003052, -0 >,
        < -0, 78.203598022, 0 >,
        < 0.000024927, 5.686100006, 0.000011603 >,
        < -0, -22.695999146, 0 >,
        < 0.000008712, 67.66570282, -0 >,
        < -0, -91.555999756, 0 >,
        < -0, -67.237998962, 0 >,
        < 0.000008712, -92.127998352, -0 >,
        < 0.000008712, 67.66570282, -0 >,
        < -0, -22.695999146, 0 >,
        < -0, 90, 0 >,
        < -0, -77.397003174, 0 >
    ]

    foreach ( int index, vector origin in origins )
    {
        entity forklift = CreateClientsideScriptMover( AIRBASE_FORKLIFT, origin, angles[index] )
        forklift.EnableRenderAlways()
        file.forklifts.append( forklift )
    }
    printt( "AIRBASE_FORKLIFT_RENDER_READY", file.forklifts.len() )
}

void function TF1AirbaseForklift_Shutdown()
{
    foreach ( entity forklift in file.forklifts )
    {
        if ( IsValid( forklift ) )
            forklift.Destroy()
    }
    file.forklifts.clear()
}
