global function TF1AirbaseForklift_Precache
global function TF1AirbaseForklift_Init
global function TF1AirbaseForklift_Shutdown

const asset AIRBASE_FORKLIFT = $"models/tf1_mapcache/mp_tf1_airbase/c3e8800dcc9b2fa7e5bc.mdl"

struct
{
    entity forklift
} file

void function TF1AirbaseForklift_Precache()
{
    if ( GetMapName() == "mp_tf1_airbase" )
        PrecacheModel( AIRBASE_FORKLIFT )
}

void function TF1AirbaseForklift_Init()
{
    if ( GetMapName() != "mp_tf1_airbase" || IsValid( file.forklift ) )
        return

    // The BSP retains the original collision for static prop 14713.
    file.forklift = CreateClientsideScriptMover( AIRBASE_FORKLIFT, < -2539, -3678, 96 >, < 0, -22.696, 0 > )
    file.forklift.EnableRenderAlways()
    printt( "AIRBASE_FORKLIFT_RENDER_READY" )
}

void function TF1AirbaseForklift_Shutdown()
{
    if ( IsValid( file.forklift ) )
        file.forklift.Destroy()
}

