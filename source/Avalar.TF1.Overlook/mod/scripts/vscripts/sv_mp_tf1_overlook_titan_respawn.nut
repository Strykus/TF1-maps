untyped
global function TF1Overlook_RegisterReplacementSpawns
void function TF1Overlook_RegisterReplacementSpawns()
{
 AddSpawnCallback("info_replacement_titan_spawn", TF1Overlook_InitReplacementSpawn)
}
void function TF1Overlook_InitReplacementSpawn(entity point)
{
 point.s.inUse <- false
 point.s.lastUsedTime <- -999
}
