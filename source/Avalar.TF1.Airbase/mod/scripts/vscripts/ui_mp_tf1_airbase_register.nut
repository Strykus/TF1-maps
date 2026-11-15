global function TF1Port_mp_tf1_airbase_Register

void function TF1Port_mp_tf1_airbase_Register()
{
    AddCallback_OnCustomGamemodesInit( TF1Port_mp_tf1_airbase_Register_AddMap )
}

void function TF1Port_mp_tf1_airbase_Register_AddMap()
{
    AddPrivateMatchMap( "mp_tf1_airbase" )
}
