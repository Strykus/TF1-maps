global function TF1LagoonStraton_Precache
global function TF1LagoonStraton_Init
global function TF1LagoonStraton_Shutdown

const asset LAGOON_STRATON_MODEL = $"models/tf1_mapcache/mp_tf1_lagoon/51fcf9e6793291e56af4.mdl"

struct
{
    array<entity> aircraft
} file

void function TF1LagoonStraton_Precache()
{
    if ( GetMapName() == "mp_tf1_lagoon" )
        PrecacheModel( LAGOON_STRATON_MODEL )
}

void function TF1LagoonStraton_Init()
{
    if ( GetMapName() != "mp_tf1_lagoon" || file.aircraft.len() != 0 )
        return

    // The static BSP props provide collision. These clientside models provide the render mesh.
    array<vector> origins = [ < -3416.88989, 5014.35986, 1124.0 >, < 1412.0, 5900.0, 454.0 > ]
    array<vector> angles = [ < 0.0, 62.1353989, 0.0 >, < 0.0, 140.852005, 0.0 > ]
    foreach ( int index, vector origin in origins )
    {
        entity aircraft = CreateClientsideScriptMover( LAGOON_STRATON_MODEL, origin, angles[index] )
        aircraft.EnableRenderAlways()
        file.aircraft.append( aircraft )
    }
    printt( "TF1_LAGOON_STRATON_READY", file.aircraft.len() )
}

void function TF1LagoonStraton_Shutdown()
{
    foreach ( entity aircraft in file.aircraft )
    {
        if ( IsValid( aircraft ) )
            aircraft.Destroy()
    }
    file.aircraft.clear()
}
