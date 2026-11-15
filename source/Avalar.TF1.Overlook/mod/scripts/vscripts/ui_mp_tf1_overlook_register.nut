global function TF1Port_mp_tf1_overlook_Register

void function TF1Port_mp_tf1_overlook_Register()
{
    AddCallback_OnCustomGamemodesInit( TF1Port_mp_tf1_overlook_Register_AddMap )
}

void function TF1Port_mp_tf1_overlook_Register_AddMap()
{
    AddPrivateMatchMap( "mp_tf1_overlook" )
}
