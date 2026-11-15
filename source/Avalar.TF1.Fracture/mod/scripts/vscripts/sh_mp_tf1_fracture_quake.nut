global function TF1FractureQuake_Register

void function TF1FractureQuake_Register()
{
 AddCallback_OnRegisteringCustomNetworkVars( TF1FractureQuake_RegisterCallbacks )
}

void function TF1FractureQuake_RegisterCallbacks()
{
 Remote_RegisterFunction( "ServerCallback_TF1FractureCrackEffects" )
 Remote_RegisterFunction( "ServerCallback_TF1FracturePlateStrike" )
}
