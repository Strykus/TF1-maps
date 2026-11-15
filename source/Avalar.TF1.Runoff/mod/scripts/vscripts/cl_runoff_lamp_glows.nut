global function RunoffLampGlows_Init

void function RunoffLampGlows_Init()
{
 if ( GetMapName() != "mp_tf1_runoff" ) return
 PrecacheParticleSystem($"acl_light_white")
 thread RunoffLampGlows_Start()
}

void function RunoffLampGlows_StartAt( vector position, vector angles )
{
 int index = GetParticleSystemIndex( $"acl_light_white" )
 if ( index < 0 ) return
 for ( int i = 0; i < 1; i++ )
  StartParticleEffectInWorldWithHandle( index, position, angles )
}

void function RunoffLampGlows_Start()
{
 wait 3
 RunoffLampGlows_StartAt( Vector(-1017, -1088, 794), Vector(48.1151, 0, 0) )
 RunoffLampGlows_StartAt( Vector(127.343, -324.392, 1379.55), Vector(48.1151, 180, 0) )
 RunoffLampGlows_StartAt( Vector(406.772, -610.231, 1379.56), Vector(48.1151, -90, 0) )
 RunoffLampGlows_StartAt( Vector(409.575, -36.1344, 1379), Vector(48.1151, 90, 0) )
 RunoffLampGlows_StartAt( Vector(684.507, -326.74, 1379.95), Vector(48.1151, 0, 0) )
 RunoffLampGlows_StartAt( Vector(117.343, -1926.39, 1362.55), Vector(48.1151, 180, 0) )
 RunoffLampGlows_StartAt( Vector(405.772, -2213.23, 1362.56), Vector(48.1151, -90, 0) )
 RunoffLampGlows_StartAt( Vector(408.575, -1657.13, 1364), Vector(48.1151, 90, 0) )
 RunoffLampGlows_StartAt( Vector(691.507, -1928.74, 1362.95), Vector(48.1151, 0, 0) )
 RunoffLampGlows_StartAt( Vector(-2248, -1927, 794), Vector(48.1151, -90, 0) )
 RunoffLampGlows_StartAt( Vector(-1020, -1179, 494), Vector(48.1151, 0, 0) )
 RunoffLampGlows_StartAt( Vector(-1020, -989, 494), Vector(48.1151, 0, 0) )
}
