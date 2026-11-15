global function TF1Outpost_EmplacementsPrecache
global function TF1Outpost_EmplacementsInit

const asset TF1_OUTPOST_CANNON_BASE = $"models/weapons/railgun_outpost_207/railgun_outpost_01_base_dynamic_tf1outpos.mdl"
const asset TF1_OUTPOST_CANNON_BARREL = $"models/weapons/railgun_outpost_207/railgun_outpost_01_barrel_tf1outpos.mdl"

void function TF1Outpost_EmplacementsPrecache()
{
 if ( GetMapName() != "mp_tf1_outpost_207" ) return
 PrecacheModel( TF1_OUTPOST_CANNON_BASE )
 PrecacheModel( TF1_OUTPOST_CANNON_BARREL )
}

void function TF1Outpost_EmplacementsInit()
{
 if ( GetMapName() != "mp_tf1_outpost_207" ) return
 AddCallback_EntitiesDidLoad( TF1Outpost_SpawnCannon )
}

entity function TF1Outpost_CreateCannonProp( asset model, vector origin, vector angles, entity mover )
{
 entity prop = CreatePropDynamic( model, origin, angles, 6 )
 prop.SetParent( mover, "", false, 0.0 )
 prop.SetLocalOrigin( < 0, 0, 0 > )
 prop.SetLocalAngles( < 0, 0, 0 > )
 return prop
}

void function TF1Outpost_SpawnCannon()
{
 array<entity> bases = GetEntArrayByScriptName( "outpost_cannon_base" )
 array<entity> barrels = GetEntArrayByScriptName( "outpost_cannon_barrel" )
 if ( bases.len() != 0 || barrels.len() != 0 )
 {
  Assert( bases.len() == 1 && barrels.len() == 1, "Outpost cannon is only partially present" )
  return
 }
 vector origin = < -60.4383, -735.946, 320 >
 vector angles = < 0, 90, 0 >
 entity baseMover = CreateScriptMover( origin, angles )
 entity base = TF1Outpost_CreateCannonProp( TF1_OUTPOST_CANNON_BASE, origin, angles, baseMover )
 base.SetScriptName( "outpost_cannon_base" )
 int attachment = base.LookupAttachment( "barrel_attachment" )
 Assert( attachment > 0, "Outpost cannon barrel attachment is missing" )
 vector barrelOrigin = base.GetAttachmentOrigin( attachment )
 vector barrelAngles = base.GetAttachmentAngles( attachment ) + < 10, 0, 0 >
 entity barrelMover = CreateScriptMover( barrelOrigin, barrelAngles )
 entity barrel = TF1Outpost_CreateCannonProp( TF1_OUTPOST_CANNON_BARREL, barrelOrigin, barrelAngles, barrelMover )
 barrel.SetScriptName( "outpost_cannon_barrel" )
 barrel.Anim_Play( "flaps_close_idle" )
 printt( "TF1_OUTPOST_CANNON_READY", base.GetOrigin(), barrel.GetOrigin() )
}
