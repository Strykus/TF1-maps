global function TF1IntroNames_Init

table<entity,bool> TF1IntroNames_tracking

void function TF1IntroNames_Init()
{
	if ( GetMapName() != "mp_tf1_outpost_207" )
		return
	AddCallback_EntitiesDidLoad( TF1IntroNames_Start )
}

void function TF1IntroNames_Start()
{
	thread TF1IntroNames_Watch()
}

void function TF1IntroNames_Watch()
{
	while ( true )
	{
		entity viewer = GetLocalViewPlayer()
		if ( IsValid( viewer ) && !IsWatchingReplay() )
		{
			if ( viewer.GetTeam() == TEAM_MILITIA )
			{
				TF1IntroNames_Find( "tf1_intro_name_mcor_riggins", "#NPC_LT_RIGGINS", TEAM_MILITIA )
				TF1IntroNames_Find( "tf1_intro_name_mcor_grunt", "#NPC_GRUNT_MILITIA", TEAM_MILITIA )
			}
			else if ( viewer.GetTeam() == TEAM_IMC )
			{
				TF1IntroNames_Find( "tf1_intro_name_imc_pilot", "#NPC_SGT_MESSERLY", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_heppe", "#NPC_PVT_HEPPE", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_booting", "#BOOTING", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_messerly", "#NPC_SGT_MESSERLY", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_keating", "#NPC_PFC_KEATING", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_pad_spectre", "#NPC_OUTPOST_DEFENSE_SPECTRE", TEAM_IMC )
				TF1IntroNames_Find( "tf1_intro_name_imc_lab_spectre", "#NPC_PFC_KEATINGS_SPECTRE", TEAM_IMC )
			}
		}
		wait 0.25
	}
}

void function TF1IntroNames_Find( string tag, string title, int team )
{
	foreach ( entity actor in GetEntArrayByScriptName( tag ) )
	{
		if ( !IsValid( actor ) || actor in TF1IntroNames_tracking )
			continue
		TF1IntroNames_tracking[actor] <- true
		thread TF1IntroNames_Track( actor, tag, title, team )
	}
}

void function TF1IntroNames_Track( entity actor, string tag, string title, int team )
{
	actor.EndSignal( "OnDestroy" )
	var rui = CreateCockpitRui( $"ui/overhead_icon_evac.rpak" )
	OnThreadEnd(
		function() : ( actor, rui )
		{
			RuiDestroy( rui )
			if ( actor in TF1IntroNames_tracking )
				delete TF1IntroNames_tracking[actor]
		}
	)
	RuiSetString( rui, "statusText", title )
	RuiSetImage( rui, "icon", $"rui/tf1_outpost_intro/blank" )
	RuiSetGameTime( rui, "finishTime", RUI_BADGAMETIME )
	RuiSetBool( rui, "isVisible", false )
	int head = actor.LookupAttachment( "HEADSHOT" )
	if ( head > 0 )
		RuiTrackFloat3( rui, "pos", actor, RUI_TRACK_POINT_FOLLOW, head )
	else
		RuiTrackFloat3( rui, "pos", actor, RUI_TRACK_OVERHEAD_FOLLOW )
	printt( "TF1_INTRO_NAME_CLIENT", tag, head )
	while ( IsValid( actor ) && actor.GetScriptName() == tag && ( !actor.IsNPC() || IsAlive( actor ) ) )
	{
		entity viewer = GetLocalViewPlayer()
		bool visible = false
		if ( IsValid( viewer ) && viewer.GetTeam() == team && !IsWatchingReplay() )
		{
			vector target = head > 0 ? actor.GetAttachmentOrigin( head ) : actor.GetOrigin() + Vector( 0, 0, actor.GetBoundingMaxs().z )
			TraceResults trace = TraceLine( viewer.EyePosition(), target, [ viewer, actor ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
			visible = !trace.startSolid && trace.fraction >= 0.99
		}
		RuiSetBool( rui, "isVisible", visible )
		wait 0.2
	}
}
