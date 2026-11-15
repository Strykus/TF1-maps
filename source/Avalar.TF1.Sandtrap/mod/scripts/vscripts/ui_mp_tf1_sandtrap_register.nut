global function TF1Port_mp_tf1_sandtrap_Register

void function TF1Port_mp_tf1_sandtrap_Register()
{
    AddCallback_OnCustomGamemodesInit( TF1Port_mp_tf1_sandtrap_Register_AddMap )
}

void function TF1Port_mp_tf1_sandtrap_Register_AddMap()
{
    AddPrivateMatchMap( "mp_tf1_sandtrap" )
}
