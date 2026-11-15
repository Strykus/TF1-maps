global function TF1OverlookDogfight_Init

const asset STRATON = $"models/vehicle/straton/straton_imc_gunship_01.mdl"
const asset HORNET = $"models/vehicle/hornet/hornet_fighter.mdl"

void function TF1OverlookDogfight_Init()
{
    if ( GetMapName() != "mp_tf1_overlook" )
        return

    PrecacheModel( STRATON )
    PrecacheModel( HORNET )
    AddCallback_GameStateEnter( eGameState.Playing, TF1OverlookDogfight_Start )
}

void function TF1OverlookDogfight_Start()
{
    thread TF1OverlookDogfight_Run()
}

void function TF1OverlookDogfight_Run()
{
    wait 5.0
    array<string> targets = [ "st_Dogfight_Target_1", "st_Dogfight_Target_2", "st_Dogfight_Target_3" ]
    array<string> pursuers = [ "st_Dogfight_Persuer_1", "st_Dogfight_Persuer_2", "st_Dogfight_Persuer_3" ]
    vector origin = <0, 0, 6100>
    while ( GetGameState() == eGameState.Playing )
    {
        for ( int i = 0; i < 40 && GetGameState() == eGameState.Playing; i++ )
        {
            int index = RandomInt( targets.len() )
            vector angles = <0, 0, 0>
            angles.y = float( RandomInt( 360 ) )
            thread TF1OverlookDogfight_Play( origin, angles, targets[index], pursuers[index] )
            float interval = 4.0 + float( RandomInt( 3 ) )
            if ( i >= 20 )
                interval = 8.0 + float( RandomInt( 13 ) )
            wait interval
            if ( i == 19 )
                wait 20.0
        }
        wait 40.0
    }
}

void function TF1OverlookDogfight_Play( vector origin, vector angles, string targetAnim, string pursuerAnim )
{
    entity target = CreatePropDynamic( STRATON, origin, angles )
    entity pursuer = CreatePropDynamic( HORNET, origin, angles )
    float targetDuration = target.GetSequenceDuration( targetAnim )
    float pursuerDuration = pursuer.GetSequenceDuration( pursuerAnim )
    if ( targetDuration > 0.0 && pursuerDuration > 0.0 )
    {
        printt( "TF1_OVERLOOK_DOGFIGHT", targetAnim, targetDuration, pursuerAnim, pursuerDuration )
        thread PlayAnim( target, targetAnim, origin, angles )
        wait 1.0
        waitthread PlayAnim( pursuer, pursuerAnim, origin, angles )
    }
    if ( IsValid( target ) )
        target.Destroy()
    if ( IsValid( pursuer ) )
        pursuer.Destroy()
}


