untyped

global function TF1Port_mp_tf1_outpost_207_Turrets_Precache
global function TF1Port_mp_tf1_outpost_207_Turrets_Init

// TF1 mega turrets (npc_turret_mega in the BSP) only target Titans in TF2
// multiplayer, so this driver picks targets, aims and fires the model's four
// muzzles itself. Rules follow TF1 mp/_ai_turret.nut:
// - a turret starts neutral, powered down and invulnerable;
// - hacking the prop_control_panel whose "target" names it (3 s, 1.1 s with
//   Fast Hack) activates it for the hacker's team at full health (8000);
// - while it is alive only the enemy team can hack it; a takeover powers it
//   down, invulnerable, for 2.5 s before it fights for the new team;
// - at 0 health it powers down and turns neutral, and either team can hack it
//   again straight away (no other cooldown);
// - it is released when its hacker disconnects.

const float TF1Port_mp_tf1_outpost_207_TURRET_RANGE = 6000.0 // TF1 maxEnemyDist
const float TF1Port_mp_tf1_outpost_207_TURRET_THINK = 0.2
const float TF1Port_mp_tf1_outpost_207_TURRET_INFANTRY_RANGE = 1770.0 // about 45 m: 32 damage at point blank falling to 15
const int TF1Port_mp_tf1_outpost_207_TURRET_HEALTH = 8000
const float TF1Port_mp_tf1_outpost_207_TURRET_TAKEOVER_DELAY = 2.5

struct
{
	table<int, bool> driven
	table<int, bool> linkedPanels
	table<int, bool> active
	table<int, entity> owner
	table<int, entity> panel
} file

// The turret AI settings force turret_heavy.mdl onto every npc_turret_mega, so
// the native model has to be applied to each turret entity at runtime.
// Its eyes attachment must retain the index cached from turret_heavy.mdl.
const asset TF1Port_mp_tf1_outpost_207_TURRET_MODEL = $"models/tf1_mapcache/mp_tf1_outpost_207/4b03e97db944bcad46ba.mdl"
const asset TF1Port_mp_tf1_outpost_207_TURRET_MUZZLE_FX = $"wpn_muzzleflash_mega_trrt"
const asset TF1Port_mp_tf1_outpost_207_TURRET_SHELL_FX = $"wpn_shelleject_40mm"
const float TF1Port_mp_tf1_outpost_207_TURRET_BARREL_DELAY = 0.04
// Stock npc_turret_mega settings (maxEnemyDist 0) make the AI drop every non-Titan
// enemy, so it never aims at pilots. The porter merges TF1's 6000 range into those
// settings through Northstar's keyvalues override (mod root), keeping the stock target info
// UI (icon and hacker name).

void function TF1Port_mp_tf1_outpost_207_Turrets_Precache()
{
	if ( GetMapName() != "mp_tf1_outpost_207" )
		return
	PrecacheModel( TF1Port_mp_tf1_outpost_207_TURRET_MODEL )
	PrecacheParticleSystem( TF1Port_mp_tf1_outpost_207_TURRET_MUZZLE_FX )
	PrecacheParticleSystem( TF1Port_mp_tf1_outpost_207_TURRET_SHELL_FX )
}

void function TF1Port_mp_tf1_outpost_207_Turrets_Init()
{
	if ( GetMapName() != "mp_tf1_outpost_207" )
		return
	RegisterSignal( "TF1Port_mp_tf1_outpost_207_TurretCapture" )
	AddDamageCallback( "npc_turret_mega", TF1Port_mp_tf1_outpost_207_Turrets_OnDamage )
	thread TF1Port_mp_tf1_outpost_207_Turrets_Manage()
}

bool function TF1Port_mp_tf1_outpost_207_Turrets_IsActive( entity turret )
{
	int handle = turret.GetEncodedEHandle()
	return handle in file.active && file.active[ handle ]
}

// TF1 ReleaseTurret: neutral, powered down, invulnerable; the panel is usable by everyone.
void function TF1Port_mp_tf1_outpost_207_Turrets_Release( entity turret )
{
	int handle = turret.GetEncodedEHandle()
	turret.Signal( "TF1Port_mp_tf1_outpost_207_TurretCapture" )
	file.active[ handle ] <- false
	file.owner[ handle ] <- null
	turret.ClearEnemy()
	turret.ClearBossPlayer()
	SetTeam( turret, TEAM_UNASSIGNED )
	MakeTurretInvulnerable( turret )
	turret.DisableTurret()
	if ( handle in file.panel && IsValid( file.panel[ handle ] ) )
		file.panel[ handle ].SetUsableByGroup( "pilot" )
}

// A turret never dies: like TF1's dead turret it powers down and waits to be hacked again.
void function TF1Port_mp_tf1_outpost_207_Turrets_OnDamage( entity turret, var damageInfo )
{
	if ( !( turret.GetEncodedEHandle() in file.driven ) )
		return
	if ( DamageInfo_GetDamage( damageInfo ) < turret.GetHealth() )
		return
	DamageInfo_SetDamage( damageInfo, 0 )
	if ( !TF1Port_mp_tf1_outpost_207_Turrets_IsActive( turret ) )
		return
	TF1Port_mp_tf1_outpost_207_Turrets_Release( turret )
	printt( "TF1_TURRET destroyed", turret.GetTargetName() )
}

void function TF1Port_mp_tf1_outpost_207_Turrets_Manage()
{
	wait 10.0
	while ( true )
	{
		foreach ( entity turret in GetNPCArrayByClass( "npc_turret_mega" ) )
		{
			int handle = turret.GetEncodedEHandle()
			if ( handle in file.driven )
				continue
			file.driven[ handle ] <- true
			thread TF1Port_mp_tf1_outpost_207_Turrets_Drive( turret )
		}
		TF1Port_mp_tf1_outpost_207_Turrets_LinkPanels()
		wait 5.0
	}
}

// Stock MP only stubs the mega turret panel link (GetMegaTurretLinkedToPanel),
// so the BSP's panel -> turret "target" key is resolved here.
void function TF1Port_mp_tf1_outpost_207_Turrets_LinkPanels()
{
	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		int handle = panel.GetEncodedEHandle()
		if ( handle in file.linkedPanels || !( "useFuncArray" in panel.s ) )
			continue
		string targetName = panel.HasKey( "target" ) ? expect string( panel.kv.target ) : ""
		if ( targetName == "" )
			continue
		foreach ( entity turret in GetNPCArrayByClass( "npc_turret_mega" ) )
		{
			if ( turret.GetTargetName() != targetName )
				continue
			file.linkedPanels[ handle ] <- true
			SetControlPanelUseFunc( panel, TF1Port_mp_tf1_outpost_207_Turrets_PanelHacked, turret )
			printt( "TF1_TURRET panel linked", targetName )
			break
		}
	}
}

// Untyped because the stock panel helper stores its callback as var.
function TF1Port_mp_tf1_outpost_207_Turrets_PanelHacked( panel, player, turret )
{
	expect entity( panel )
	expect entity( player )
	expect entity( turret )
	if ( !IsValid( turret ) || !IsAlive( turret ) || !IsValid( player ) )
		return
	int team = player.GetTeam()
	file.panel[ turret.GetEncodedEHandle() ] <- panel
	PanelFlipsToPlayerTeamAndUsableByEnemies( panel, player )
	thread TF1Port_mp_tf1_outpost_207_Turrets_Capture( turret, team, player )
	SendHudMessage( player, "Mega turret now fights for your team", -1, 0.4, 200, 200, 255, 255, 0.15, 3.0, 0.5 )
	printt( "TF1_TURRET hacked", turret.GetTargetName(), "team", team, "by", player.GetPlayerName() )
}

// TF1 CaptureTurret.
void function TF1Port_mp_tf1_outpost_207_Turrets_Capture( entity turret, int team, entity player )
{
	turret.Signal( "TF1Port_mp_tf1_outpost_207_TurretCapture" )
	turret.EndSignal( "TF1Port_mp_tf1_outpost_207_TurretCapture" )
	turret.EndSignal( "OnDestroy" )
	int handle = turret.GetEncodedEHandle()
	if ( TF1Port_mp_tf1_outpost_207_Turrets_IsActive( turret ) && turret.GetTeam() != team )
	{
		file.active[ handle ] <- false
		turret.ClearEnemy()
		MakeTurretInvulnerable( turret )
		turret.DisableTurret()
		wait TF1Port_mp_tf1_outpost_207_TURRET_TAKEOVER_DELAY
	}
	SetTeam( turret, team )
	turret.SetHealth( turret.GetMaxHealth() )
	MakeTurretVulnerable( turret )
	turret.EnableTurret()
	turret.ai.readyToFire = false
	turret.ClearEnemy()
	if ( IsValid( player ) )
		turret.SetBossPlayer( player )
	file.owner[ handle ] <- player
	file.active[ handle ] <- true
}

entity function TF1Port_mp_tf1_outpost_207_Turrets_FindTarget( entity turret, vector muzzle )
{
	int team = turret.GetTeam()
	array<entity> candidates
	foreach ( entity player in GetPlayerArray() )
	{
		if ( player.GetTeam() != team )
			candidates.append( player )
	}
	foreach ( entity npc in GetNPCArray() )
	{
		if ( npc == turret || npc.GetTeam() == team )
			continue
		candidates.append( npc )
	}

	entity best = null
	float bestDistance = TF1Port_mp_tf1_outpost_207_TURRET_RANGE
	foreach ( entity candidate in candidates )
	{
		if ( !IsValid( candidate ) || !IsAlive( candidate ) || candidate.GetNoTarget() )
			continue
		vector center = candidate.GetWorldSpaceCenter()
		float distance = Distance( muzzle, center )
		if ( distance >= bestDistance )
			continue
		TraceResults sight = TraceLine( muzzle, center, [ turret, candidate ], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		if ( sight.fraction < 0.98 )
			continue
		best = candidate
		bestDistance = distance
	}
	return best
}

void function TF1Port_mp_tf1_outpost_207_Turrets_Drive( entity turret )
{
	turret.EndSignal( "OnDestroy" )
	turret.EndSignal( "OnDeath" )

	turret.SetModel( TF1Port_mp_tf1_outpost_207_TURRET_MODEL )
	printt( "TF1_TURRET model", turret.GetModelName(), "maxEnemyDist", turret.GetMaxEnemyDist() )
	turret.SetMaxHealth( TF1Port_mp_tf1_outpost_207_TURRET_HEALTH )
	turret.SetHealth( TF1Port_mp_tf1_outpost_207_TURRET_HEALTH )
	// The stock weapon script fires the engine's own shots from the muzzle_flash tag only;
	// the volley below fires every barrel instead.
	turret.ai.readyToFire = false
	turret.SetEfficientMode( false )
	turret.DisableHibernation()
	TF1Port_mp_tf1_outpost_207_Turrets_Release( turret )

	array<string> muzzles = [ "MUZZLE_LEFT_UPPER", "MUZZLE_RIGHT_UPPER", "MUZZLE_LEFT_LOWER", "MUZZLE_RIGHT_LOWER" ]
	array<string> shells = [ "SHELL_LEFT_UPPER", "SHELL_RIGHT_UPPER", "SHELL_LEFT_LOWER", "SHELL_RIGHT_LOWER" ]
	int muzzleFx = GetParticleSystemIndex( TF1Port_mp_tf1_outpost_207_TURRET_MUZZLE_FX )
	int shellFx = GetParticleSystemIndex( TF1Port_mp_tf1_outpost_207_TURRET_SHELL_FX )
	printt( "TF1_TURRET fx", muzzleFx, shellFx )
	int handle = turret.GetEncodedEHandle()
	entity lastTarget = null
	while ( true )
	{
		wait TF1Port_mp_tf1_outpost_207_TURRET_THINK
		if ( !TF1Port_mp_tf1_outpost_207_Turrets_IsActive( turret ) )
			continue
		entity owner = file.owner[ handle ]
		if ( !IsValid( owner ) )
		{
			TF1Port_mp_tf1_outpost_207_Turrets_Release( turret )
			continue
		}
		// The engine never lets a turret aim at its boss player, so drop that link if the hacker changes sides.
		if ( turret.GetBossPlayer() == owner && owner.GetTeam() != turret.GetTeam() )
			turret.ClearBossPlayer()
		entity weapon = turret.GetActiveWeapon()
		if ( !IsValid( weapon ) )
			continue

		int lead = turret.LookupAttachment( muzzles[ 0 ] )
		if ( lead <= 0 )
			continue
		vector leadMuzzle = turret.GetAttachmentOrigin( lead )
		entity target = TF1Port_mp_tf1_outpost_207_Turrets_FindTarget( turret, leadMuzzle )
		if ( !IsValid( target ) )
			continue

		if ( turret.GetEnemy() != target )
			turret.SetEnemy( target )
		if ( target != lastTarget )
		{
			lastTarget = target
			printt( "TF1_TURRET target", turret.GetTargetName(), "team", turret.GetTeam(), "->", target.GetClassName(), "team", target.GetTeam() )
		}
		turret.SetEnemyLKP( target, target.GetOrigin() )
		vector aim = target.GetWorldSpaceCenter()
		if ( DotProduct( AnglesToForward( turret.GetAttachmentAngles( lead ) ), Normalize( aim - leadMuzzle ) ) < 0.98 )
			continue

		// One volley per think, like the singleplayer turret: every barrel fires with
		// its own flash, shell eject and the model's recoil gesture. The stock weapon
		// script only flashes the "muzzle_flash" tag for non turret_heavy models.
		turret.Anim_Play( "attack" )
		for ( int barrel = 0; barrel < muzzles.len(); barrel++ )
		{
			int attachment = turret.LookupAttachment( muzzles[ barrel ] )
			if ( attachment <= 0 || !IsValid( weapon ) )
				continue
			vector muzzle = turret.GetAttachmentOrigin( attachment )
			vector barrelDirection = AnglesToForward( turret.GetAttachmentAngles( attachment ) )
			// Tracer only; damage is applied once per volley below with TF1's values.
			weapon.FireWeaponBullet_Special( muzzle, barrelDirection, 1, 0, true, false, true, false, false, false, false )
			if ( muzzleFx >= 0 )
				StartParticleEffectOnEntity( turret, muzzleFx, FX_PATTACH_POINT_FOLLOW, attachment )
			int shellAttachment = turret.LookupAttachment( shells[ barrel ] )
			if ( shellFx >= 0 && shellAttachment > 0 )
				StartParticleEffectOnEntity( turret, shellFx, FX_PATTACH_POINT_FOLLOW, shellAttachment )
			// One fire sound per barrel, like the stock weapon script (one per shot), sent to
			// each player from the muzzle so the turret's own team hears it too. Sixteen
			// overlapping copies give 16x the amplitude (user asked for x2, x2, then x4).
			foreach ( entity listener in GetPlayerArray() )
			{
				for ( int copy = 0; copy < 16; copy++ )
					EmitSoundAtPositionOnlyToPlayer( TEAM_ANY, muzzle, listener, "megaturret_fire" )
			}
			if ( barrel == 0 )
				weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
			if ( barrel < muzzles.len() - 1 )
				wait TF1Port_mp_tf1_outpost_207_TURRET_BARREL_DELAY
		}

		if ( !IsValid( target ) || !IsAlive( target ) )
			continue
		aim = target.GetWorldSpaceCenter()
		float distance = Distance( leadMuzzle, aim )
		float damage = 200.0
		if ( !target.IsTitan() )
			damage = GraphCapped( distance, 0.0, TF1Port_mp_tf1_outpost_207_TURRET_INFANTRY_RANGE, 32.0, 15.0 )
		target.TakeDamage( damage, turret, turret, { origin = aim, damageSourceId = eDamageSourceId.mp_weapon_mega_turret } )
	}
}
