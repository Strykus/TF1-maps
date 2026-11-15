global function TF1SwampScenes_RemoteInit
global function TF1SwampScenes_LeviathanAnimations

void function TF1SwampScenes_RemoteInit()
{
	AddCallback_OnRegisteringCustomNetworkVars( TF1SwampScenes_RegisterRemote )
}

void function TF1SwampScenes_RegisterRemote()
{
	Remote_RegisterFunction( "ServerCallback_TF1SwampLeviathan" )
	Remote_RegisterFunction( "ServerCallback_TF1SwampLeviathanRemove" )
	Remote_RegisterFunction( "ServerCallback_TF1SwampPulse" )
}

array<string> function TF1SwampScenes_LeviathanAnimations()
{
	return [
		"lev_walk_slow", "lev_walk_slow_left", "lev_walk_slow_right",
		"leviathan_walk_fast", "leviathan_walk_fast_left", "leviathan_walk_fast_right",
		"leviathan_walk_fast_left_sharp", "leviathan_walk_fast_right_sharp",
		"leviathan_walk_90turn_left", "leviathan_walk_90turn_right",
		"leviathan_walk_180turn_left", "leviathan_walk_180turn_right",
		"leviathan_trans_2_walk_fast", "lev_trans_2_walk_slow",
		"leviathan_trans_2_idle_fast", "lev_trans_2_idle",
		"lev_idle_lookup_noloop", "leviathan_reaction_howl"
	]
}
