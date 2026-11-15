untyped

global function TF1OutpostIntroScreen_RemoteInit

#if CLIENT
global function ServerCallback_TF1OutpostIntroScreen
#endif

const float TF1_OUTPOST_TITLE_DELAY = 0.2
const float TF1_OUTPOST_TITLE_FADE_IN = 1.2
const float TF1_OUTPOST_TITLE_DISPLAY = 9.0
const float TF1_OUTPOST_TITLE_FADE_OUT = 1.2
const float TF1_OUTPOST_LOGO_DELAY = 0.5
const float TF1_OUTPOST_LOGO_FADE_IN = 2.0
const float TF1_OUTPOST_LOGO_DISPLAY_IMC = 4.5
const float TF1_OUTPOST_LOGO_DISPLAY_MILITIA = 2.0
const float TF1_OUTPOST_LOGO_FADE_OUT = 2.0
const float TF1_OUTPOST_BLACK_FADE_AT = 18.9
const float TF1_OUTPOST_BLACK_FADE_OUT = 2.0

void function TF1OutpostIntroScreen_RemoteInit()
{
	AddCallback_OnRegisteringCustomNetworkVars( TF1OutpostIntroScreen_RegisterRemote )
#if CLIENT
	if ( GetMapName() != "mp_tf1_outpost_207" )
		return
	PrecacheHUDMaterial( $"ui/tf1_outpost_intro_white" )
	PrecacheHUDMaterial( $"ui/tf1_outpost_intro_imc" )
	PrecacheHUDMaterial( $"ui/tf1_outpost_intro_militia" )
#endif
}

void function TF1OutpostIntroScreen_RegisterRemote()
{
	Remote_RegisterFunction( "ServerCallback_TF1OutpostIntroScreen" )
}

#if CLIENT
void function ServerCallback_TF1OutpostIntroScreen()
{
	if ( GetMapName() != "mp_tf1_outpost_207" || IsWatchingReplay() )
		return
	thread TF1OutpostIntroScreen_Run()
}

void function TF1OutpostIntroScreen_Run()
{
	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
	{
		printt( "TF1_OUTPOST_INTRO_SCREEN_ERROR", "missing_view_player" )
		return
	}

	local team = player.GetTeam()
	if ( team != TEAM_IMC && team != TEAM_MILITIA )
	{
		printt( "TF1_OUTPOST_INTRO_SCREEN_ERROR", "invalid_team", team )
		return
	}

	player.EndSignal( "OnDestroy" )
	local startTime = Time()
	local elements = HudElementGroup( "TF1OutpostIntro" )
	OnThreadEnd(
		function() : ( elements )
		{
			elements.Hide()
		}
	)

	local background = elements.CreateElement( "TF1OutpostIntroBackground" )
	local title = elements.CreateElement( "TF1OutpostIntroTitle" )
	local logo = elements.CreateElement( "TF1OutpostIntroLogo" )
	background.SetImage( $"ui/tf1_outpost_intro_white" )
	background.SetColor( 0, 0, 0, 255 )
	background.Show()

	title.SetText( "#INTRO_SCREEN_OUTPOST_LINE1" )
	title.SetColor( 255, 255, 255, 0 )
	title.SetAlpha( 0 )
	title.Show()
	title.FadeOverTimeDelayed( 255, TF1_OUTPOST_TITLE_FADE_IN, TF1_OUTPOST_TITLE_DELAY )

	if ( team == TEAM_IMC )
		logo.SetImage( $"ui/tf1_outpost_intro_imc" )
	else
		logo.SetImage( $"ui/tf1_outpost_intro_militia" )
	logo.SetColor( 255, 255, 255, 0 )
	logo.SetAlpha( 0 )
	printt( "TF1_OUTPOST_INTRO_SCREEN_START", team, startTime )

	wait max( 0.0, startTime + TF1_OUTPOST_TITLE_DELAY + TF1_OUTPOST_TITLE_DISPLAY - Time() )
	title.ColorOverTime( 0, 0, 0, 0, TF1_OUTPOST_TITLE_FADE_OUT, INTERPOLATOR_LINEAR )
	wait max( 0.0, startTime + TF1_OUTPOST_TITLE_DELAY + TF1_OUTPOST_TITLE_DISPLAY +
		TF1_OUTPOST_LOGO_DELAY - Time() )
	logo.Show()
	logo.ColorOverTime( 255, 255, 255, 255, TF1_OUTPOST_LOGO_FADE_IN, INTERPOLATOR_ACCEL )
	printt( "TF1_OUTPOST_INTRO_SCREEN_LOGO", team, Time() )

	local logoDisplay = team == TEAM_IMC ? TF1_OUTPOST_LOGO_DISPLAY_IMC : TF1_OUTPOST_LOGO_DISPLAY_MILITIA
	wait max( 0.0, startTime + TF1_OUTPOST_TITLE_DELAY + TF1_OUTPOST_TITLE_DISPLAY +
		TF1_OUTPOST_LOGO_DELAY + TF1_OUTPOST_LOGO_FADE_IN + logoDisplay - Time() )
	logo.ColorOverTime( 0, 0, 0, 0, TF1_OUTPOST_LOGO_FADE_OUT, INTERPOLATOR_LINEAR )

	wait max( 0.0, startTime + TF1_OUTPOST_BLACK_FADE_AT - Time() )
	printt( "TF1_OUTPOST_INTRO_SCREEN_FADE", team, Time() )
	background.FadeOverTime( 0, TF1_OUTPOST_BLACK_FADE_OUT )
	wait TF1_OUTPOST_BLACK_FADE_OUT
	printt( "TF1_OUTPOST_INTRO_SCREEN_END", team, Time() )
}
#endif
