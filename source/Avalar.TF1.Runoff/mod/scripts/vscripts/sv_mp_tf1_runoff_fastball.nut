global function TF1Port_mp_tf1_runoff_Fastball_Init

// Control panel points chosen in game with TF1.PlacementTool:
// A on the IMC side, B in the middle, C on the Militia side.
void function TF1Port_mp_tf1_runoff_Fastball_Init()
{
	if ( GetMapName() != "mp_tf1_runoff" )
		return

	FastballAddPanelSpawnsForLevel(
		"mp_tf1_runoff",
		[ < 746.734, -1767.755, 528.031 >, < 0, 0, 0 >, < -2720.513, -1105.510, 216.031 >, < 0, 0, 0 >, < 430.384, 851.395, 80.031 >, < 0, 90, 0 > ]
	)
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_runoff_Fastball_OnEntitiesLoaded )
	AddCallback_EntitiesDidLoad( TF1Port_mp_tf1_runoff_Fastball_PlaceBuddies )
	// diagnostic path log, enable when tuning BT points: AddCallback_GameStateEnter( eGameState.Prematch, TF1Port_mp_tf1_runoff_Fastball_StartPathLog )
}

// Native TF1 consoles without a Fastball panel id would break the mode.
void function TF1Port_mp_tf1_runoff_Fastball_OnEntitiesLoaded()
{
	if ( GameRules_GetGameMode() != "fastball" )
		return

	int removed = 0
	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		if ( "scriptedPanel" in panel.s )
			continue
		panel.Destroy()
		removed++
	}
	printt( "TF1_RUNOFF_FASTBALL foreign consoles removed", removed )

	thread TF1Port_mp_tf1_runoff_Fastball_SnapPanelsToFloor()
}

void function TF1Port_mp_tf1_runoff_Fastball_SnapPanelsToFloor()
{
	WaitFrame()

	foreach ( entity panel in GetEntArrayByClass_Expensive( "prop_control_panel" ) )
	{
		if ( !( "scriptedPanel" in panel.s ) )
			continue

		vector origin = panel.GetOrigin()
		TraceResults floor = TraceLine( origin + < 0, 0, 96 >, origin - < 0, 0, 160 >, panel, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( floor.startSolid || floor.fraction >= 1.0 )
		{
			printt( "TF1_RUNOFF_FASTBALL panel kept", origin )
			continue
		}

		printt( "TF1_RUNOFF_FASTBALL panel floor", origin.z, "->", floor.endPos.z )
		panel.SetOrigin( floor.endPos )
	}
}

// The BT holds the player in its hand in front of it and throws forward. The vanilla
// pick can put that hand inside railings or pipes, so every team's BT point is moved to
// the nearest spot where the body, the hand and the start of the throw are clear.
bool function TF1Port_mp_tf1_runoff_Fastball_BoxClear( vector center, vector mins, vector maxs )
{
	TraceResults t = TraceHull( center, center, mins, maxs, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	return !t.startSolid && t.fraction >= 1.0
}

// Real path of the throw animation, recorded in game (TF1_BT_PATH). Values are relative
// to the BT spawn point: forward, right, up. The BT stands about 360 units BEHIND the
// spawn point while it holds the player, then walks to the spawn point.
array<vector> function TF1Port_mp_tf1_runoff_Fastball_HandPath()
{
	return [
		< -370, -33, 73 >, < -370, 10, 120 >, < -404, 42, 181 >, < -470, 28, 157 >, < -457, 65, 171 >,
		< -441, 87, 180 >, < -450, 74, 183 >, < -464, 23, 183 >, < -468, 10, 182 >, < -474, -1, 175 >,
		< -474, 28, 176 >, < -460, 58, 180 >, < -446, 72, 182 >, < -450, 58, 183 >, < -460, 18, 187 >,
		< -461, 13, 183 >, < -462, 20, 182 >, < -464, 22, 174 >, < -486, 30, 135 >, < -384, 2, 178 >,
		< -171, 82, 194 >, < -18, -109, 80 >, < -21, -78, 41 >, < -28, -104, 89 >, < -22, -83, 92 >,
		< -185, 5, 124 >
	]
}

array<vector> function TF1Port_mp_tf1_runoff_Fastball_BodyPath()
{
	return [
		< -242, -49, 0 >, < -289, -43, 0 >, < -329, -33, 0 >, < -361, -19, 0 >, < -255, -15, 0 >,
		< -114, 2, 0 >, < -121, -54, 0 >, < -98, -67, 0 >, < -197, -52, 0 >
	]
}

vector function TF1Port_mp_tf1_runoff_Fastball_ToWorld( vector o, float yaw, vector rel )
{
	vector fwd = AnglesToForward( < 0, yaw, 0 > )
	vector right = AnglesToRight( < 0, yaw, 0 > )
	return o + fwd * rel.x + right * rel.y + < 0, 0, rel.z >
}

bool function TF1Port_mp_tf1_runoff_Fastball_BTFits( vector o, float yaw, bool strict )
{
	float hand = strict ? 40.0 : 28.0
	foreach ( vector p in TF1Port_mp_tf1_runoff_Fastball_BodyPath() )
	{
		vector c = TF1Port_mp_tf1_runoff_Fastball_ToWorld( o, yaw, p ) + < 0, 0, 8 >
		if ( !TF1Port_mp_tf1_runoff_Fastball_BoxClear( c, < -70, -70, 0 >, < 70, 70, 300 > ) )
			return false
	}
	foreach ( vector p in TF1Port_mp_tf1_runoff_Fastball_HandPath() )
	{
		vector c = TF1Port_mp_tf1_runoff_Fastball_ToWorld( o, yaw, p )
		if ( !TF1Port_mp_tf1_runoff_Fastball_BoxClear( c, < -hand, -hand, -hand >, < hand, hand, hand > ) )
			return false
	}
	return true
}
array<vector> function TF1Port_mp_tf1_runoff_Fastball_FindClear( vector o, float yaw, bool strict, float maxRadius )
{
	array<vector> none
	array<float> radii = [ 0.0, 48.0, 96.0, 144.0, 192.0, 256.0, 320.0, 400.0, 480.0 ]
	array<float> turns = [ 0.0, 45.0, -45.0, 90.0, -90.0, 135.0, -135.0, 180.0 ]
	foreach ( float radius in radii )
	{
		if ( radius > maxRadius )
			break
		foreach ( float turn in turns )
		{
			vector c = o + AnglesToForward( < 0, yaw + turn, 0 > ) * radius
			TraceResults down = TraceLine( c + < 0, 0, 96 >, c - < 0, 0, 192 >, null, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
			if ( down.fraction < 1.0 && !down.startSolid && TF1Port_mp_tf1_runoff_Fastball_BTFits( down.endPos, yaw, strict ) )
				return [ down.endPos ]
			if ( radius == 0.0 )
				break
		}
	}
	return none
}
struct
{
	table<int, array<vector> > origins
	table<int, array<float> > yaws
	table<int, int> last
} btFile

// Builds, per team, every Titan start point whose BT path is clear (moved to the nearest
// clear spot when needed) and picks one at random. It is picked again every round.
void function TF1Port_mp_tf1_runoff_Fastball_PlaceBuddies()
{
	if ( GameRules_GetGameMode() != "fastball" )
		return

	foreach ( int team in [ TEAM_IMC, TEAM_MILITIA ] )
	{
		array<vector> origins
		array<float> yaws
		foreach ( entity e in GetEntArrayByClass_Expensive( "info_spawnpoint_titan_start" ) )
		{
			if ( e.GetTeam() != team )
				continue
			array<vector> clear = TF1Port_mp_tf1_runoff_Fastball_FindClear( e.GetOrigin(), e.GetAngles().y, true, 480.0 )
			if ( clear.len() == 0 )
				continue
			origins.append( clear[0] )
			yaws.append( e.GetAngles().y )
		}
		btFile.origins[ team ] <- origins
		btFile.yaws[ team ] <- yaws
		btFile.last[ team ] <- -1
		printt( "TF1_RUNOFF_FASTBALL BT usable points", team, origins.len() )
	}

	TF1Port_mp_tf1_runoff_Fastball_PickBuddies()
	AddCallback_GameStateEnter( eGameState.Playing, TF1Port_mp_tf1_runoff_Fastball_PickBuddies )
}

void function TF1Port_mp_tf1_runoff_Fastball_PickBuddies()
{
	foreach ( int team in [ TEAM_IMC, TEAM_MILITIA ] )
		if ( !( team in btFile.origins ) || btFile.origins[ team ].len() == 0 )
			return

	foreach ( int team in [ TEAM_IMC, TEAM_MILITIA ] )
	{
		int count = btFile.origins[ team ].len()
		int index = RandomInt( count )
		if ( count > 1 && index == btFile.last[ team ] )
			index = ( index + 1 + RandomInt( count - 1 ) ) % count
		btFile.last[ team ] = index
		FastballAddBuddySpawnForLevel( "mp_tf1_runoff", team, btFile.origins[ team ][ index ], < 0, btFile.yaws[ team ][ index ], 0 > )
		printt( "TF1_RUNOFF_FASTBALL BT pick", team, index, btFile.origins[ team ][ index ] )
	}
}
// Diagnostics for the BT intro: logs where the BT hand and the held player really are
// during the throw (relative to the BT) and whether they overlap map geometry.
void function TF1Port_mp_tf1_runoff_Fastball_StartPathLog()
{
	if ( GameRules_GetGameMode() == "fastball" )
		thread TF1Port_mp_tf1_runoff_Fastball_PathLog()
}

void function TF1Port_mp_tf1_runoff_Fastball_PathLog()
{
	for ( int step = 0; step < 150; step++ )
	{
		wait 0.2
		foreach ( entity buddy in GetEntArrayByClass_Expensive( "prop_dynamic" ) )
		{
			if ( !IsValid( buddy ) )
				continue
			string modelName = string( buddy.GetModelName() )
			if ( step == 0 )
				printt( "TF1_BT_PATH model", modelName )
			if ( modelName.find( "buddy" ) == null )
				continue
			vector bo = buddy.GetOrigin()
			float yaw = buddy.GetAngles().y
			vector fwd = AnglesToForward( < 0, yaw, 0 > )
			vector right = AnglesToRight( < 0, yaw, 0 > )
			array<string> tags = [ "FASTBALL_R", "REF" ]
			foreach ( string tag in tags )
			{
				int id = buddy.LookupAttachment( tag )
				if ( id <= 0 )
					continue
				vector p = buddy.GetAttachmentOrigin( id )
				vector d = p - bo
				TraceResults hit = TraceHull( p, p, < -24, -24, -24 >, < 24, 24, 24 >, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
				printt( "TF1_BT_PATH", step, tag, "bt", bo, yaw, "local", d.x * fwd.x + d.y * fwd.y, d.x * right.x + d.y * right.y, d.z, "solid", hit.startSolid )
			}
		}
		foreach ( entity player in GetPlayerArray() )
		{
			vector e = player.EyePosition()
			TraceResults hit = TraceHull( e, e, < -12, -12, -12 >, < 12, 12, 12 >, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
			printt( "TF1_BT_PATH", step, "eye", player.GetTeam(), e, "origin", player.GetOrigin(), "vel", player.GetVelocity(), "solid", hit.startSolid )
		}
	}
}