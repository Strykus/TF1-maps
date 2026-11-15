untyped

global function TF1OutpostPanel_Init

const asset TF1_OUTPOST_PANEL_MODEL = $"models/tf1_mapcache/mp_tf1_outpost_207/2ad36862bffcb1886b42.mdl"

void function TF1OutpostPanel_Init()
{
	if ( GetMapName() != "mp_tf1_outpost_207" )
		return
	AddCreateCallback( "prop_control_panel", TF1OutpostPanel_OnCreate )
	AddDestroyCallback( "prop_control_panel", TF1OutpostPanel_OnDestroy )
}

void function TF1OutpostPanel_OnCreate( entity panel )
{
	if ( panel.GetModelName() != TF1_OUTPOST_PANEL_MODEL )
		return
	if ( "initiated" in panel.s )
	{
		Assert( "updateCallbacks" in panel.s && "VGUIFunc" in panel.s, "Outpost panel is incompletely initialized" )
		return
	}

	panel.s.HudVGUI <- null
	panel.s.VGUIFunc <- VGUIUpdateGeneric
	panel.s.VGUISetupFunc <- VGUISetupGeneric
	panel.s.targetArray <- []
	panel.s.resfile <- "control_panel_generic_screen"
	panel.s.particleEffect <- null
	panel.s.particleFlashingBlueToPlayer <- false
	if ( !( "updateCallbacks" in panel.s ) )
		panel.s.updateCallbacks <- []

	AddAnimEvent( panel, "create_dataknife", CreateFirstPersonDataKnife )
	AddAnimEvent( panel, "knife_popout", DataKnifePopsOpen )
	panel.useFunction = ControlPanel_CanUseFunction
	Create_Display( panel )
	panel.s.initiated <- true
	printt( "TF1_OUTPOST_PANEL_CLIENT_READY", panel.GetOrigin() )
}

void function TF1OutpostPanel_OnDestroy( entity panel )
{
	if ( panel.GetModelName() != TF1_OUTPOST_PANEL_MODEL )
		return
	if ( "HudVGUI" in panel.s && panel.s.HudVGUI )
	{
		panel.s.HudVGUI.Destroy()
		panel.s.HudVGUI = null
	}
	if ( "particleEffect" in panel.s && panel.s.particleEffect != null && EffectDoesExist( panel.s.particleEffect ) )
		EffectStop( panel.s.particleEffect, true, false )
}
