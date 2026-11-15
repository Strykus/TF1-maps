global function TF1IntroRamp_RemoteInit

#if CLIENT
global function ServerCallback_TF1IntroRampExposure
#endif

void function TF1IntroRamp_RemoteInit()
{
	AddCallback_OnRegisteringCustomNetworkVars( TF1IntroRamp_RegisterRemote )
}

void function TF1IntroRamp_RegisterRemote()
{
	Remote_RegisterFunction( "ServerCallback_TF1IntroRampExposure" )
}

#if CLIENT
void function ServerCallback_TF1IntroRampExposure()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
	{
		printt( "TF1_INTRO_RAMP_ERROR", "missing_view_player" )
		return
	}
	thread TF1IntroRamp_SettleExposure( player )
}

void function TF1IntroRamp_SettleExposure( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	wait 1.05
	OnThreadEnd(
		function()
		{
			AutoExposureSetMaxExposureMultiplier( 1.0 )
		}
	)
	float start = Time()
	printt( "TF1_INTRO_RAMP_EXPOSURE", start )
	while ( Time() - start < 5.0 )
	{
		float remaining = GraphCapped( Time() - start, 0.0, 5.0, 1.0, 0.0 )
		AutoExposureSetMaxExposureMultiplier( 1.0 + 9.0 * remaining )
		WaitFrame()
	}
}
#endif
