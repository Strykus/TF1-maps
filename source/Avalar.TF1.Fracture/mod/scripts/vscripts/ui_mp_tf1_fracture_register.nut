global function TF1Port_mp_tf1_fracture_Register

void function TF1Port_mp_tf1_fracture_Register()
{
    AddCallback_OnCustomGamemodesInit( TF1Port_mp_tf1_fracture_Register_AddMap )
}

void function TF1Port_mp_tf1_fracture_Register_AddMap()
{
    AddPrivateMatchMap( "mp_tf1_fracture" )
}
