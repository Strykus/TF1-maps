global function TF1FractureMachinery_Init
global function TF1FractureMachinery_Precache

void function TF1FractureMachinery_Precache()
{
 if ( GetMapName() != "mp_tf1_fracture" )
  return
 RegisterSignal( "megathumper_impact" )
 PrecacheParticleSystem( $"mp_tf1_fracture_quake_env_megathumper_dust_crack" )
}

void function TF1FractureMachinery_Init()
{
 if ( GetMapName() == "mp_tf1_fracture" )
  AddCallback_EntitiesDidLoad( TF1FractureMachinery_Start )
}

void function TF1FractureMachinery_Start()
{
 entity plate
 entity megaThumper
 int hammers = 0
 int turbines = 0

 foreach ( prop in GetEntArrayByClass_Expensive( "prop_dynamic" ) )
 {
  switch ( prop.GetTargetName() )
  {
   case "thumper_animated":
   case "thumper_animated_central":
    prop.Anim_Play( "strike" )
    hammers++
    break
   case "thumper_generator__animated_01":
   case "thumper_generator__animated_02":
    prop.Anim_Play( "idle_spinning" )
    turbines++
    break
   case "sky_plate_animated_1":
    plate = prop
    break
   case "sky_thumper_animated_1":
    megaThumper = prop
    break
  }
 }

 printt( "TF1_FRACTURE_MACHINERY_STARTED", hammers, turbines, IsValid( plate ), IsValid( megaThumper ) )
 if ( IsValid( plate ) && IsValid( megaThumper ) )
  thread TF1FractureMachinery_Earthquake( plate, megaThumper )
}

void function TF1FractureMachinery_Earthquake( entity plate, entity megaThumper )
{
 plate.EndSignal( "OnDestroy" )
 megaThumper.EndSignal( "OnDestroy" )
 plate.Anim_Play( "pre_strike" )
 megaThumper.Anim_Play( "pre_strike" )

 while ( GetGameState() < eGameState.Playing )
 {
  bool inIntro = false
  foreach ( player in GetPlayerArray() )
   if ( IsAlive( player ) && HasCinematicFlag( player, CE_FLAG_CLASSIC_MP_SPAWNING ) )
    inIntro = true
  if ( inIntro )
   break
  wait 0.05
 }
 if ( GetGameState() > eGameState.SuddenDeath )
  return

 thread TF1FractureMachinery_CrackEffects( megaThumper )
 foreach ( player in GetPlayerArray() )
  Remote_CallFunction_NonReplay( player, "ServerCallback_TF1FracturePlateStrike" )
 plate.Hide()
 megaThumper.Anim_Play( "strike" )
 printt( "TF1_FRACTURE_EARTHQUAKE_STARTED" )
 wait megaThumper.GetSequenceDuration( "strike" )
 megaThumper.Anim_Play( "post_strike" )
 printt( "TF1_FRACTURE_EARTHQUAKE_POST_STRIKE" )
}

void function TF1FractureMachinery_CrackEffects( entity megaThumper )
{
 megaThumper.WaitSignal( "megathumper_impact" )
 foreach ( player in GetPlayerArray() )
  Remote_CallFunction_NonReplay( player, "ServerCallback_TF1FractureCrackEffects" )
 printt( "TF1_FRACTURE_CRACK_BROADCAST" )
}
