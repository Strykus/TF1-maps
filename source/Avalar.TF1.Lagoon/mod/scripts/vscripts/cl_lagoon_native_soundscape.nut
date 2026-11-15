global function LagoonNativeAudio_Init
global function LagoonNativeAudio_Shutdown

struct
{
 bool stopped = false
 bool started = false
 entity listener = null
 int current = -1
 array<string> events = ["amb_lagoon_ext_global","amb_lagoon_int_temple","amb_lagoon_int_smallroom","amb_lagoon_int_closedroom","amb_lagoon_emitter_waterlap","amb_lagoon_emitter_waterlapshore","amb_lagoon_emitter_waterfalltop","amb_lagoon_emitter_waterfallbottom","amb_lagoon_emitter_stream","amb_lagoon_emitter_birdflock","amb_fracture_waterfall_bottom2","amb_fracture_waterfall_top1"]
 array<vector> origins = [Vector(1228,-688,7324),Vector(1228,-688,7324),Vector(388,5180,360),Vector(3915.79004,849.343018,924)]
 array<vector> mins = [Vector(-14340,-15208,-7932),Vector(-14340,-15208,-7932),Vector(-444,-988,-168),Vector(-1013.37134,-1223.5918,-172)]
 array<vector> maxs = [Vector(14340,15208,7932),Vector(14340,15208,7932),Vector(444,988,168),Vector(1013.36182,1223.59253,172)]
 array<int> regionEvents = [0,0,3,1]
 array<array<vector> > triangles = [[Vector(14340,-15208,-128),Vector(14340,-15208,7932),Vector(14340,14624,7932),Vector(14340,14624,-128),Vector(14340,-15208,-128),Vector(14340,14624,7932),Vector(14340,6720,-7932),Vector(14340,6720,-1024),Vector(14340,14400,-1024),Vector(14340,14400,-1024),Vector(14340,14400,-7932),Vector(14340,6720,-7932),Vector(-9312,-15208,-1024),Vector(-9312,-15208,-3072),Vector(-12896,-15208,-3072),Vector(-12896,-15208,-3072),Vector(-12896,-15208,-1024),Vector(-9312,-15208,-1024),Vector(14340,-15208,7932),Vector(14340,-15208,-128),Vector(-13120,-15208,-128),Vector(-13120,-15208,7932),Vector(14340,-15208,7932),Vector(-13120,-15208,-128),Vector(14340,14400,-7932),Vector(7840,14400,-7932),Vector(7840,6720,-7932),Vector(7840,6720,-7932),Vector(14340,6720,-7932),Vector(14340,14400,-7932),Vector(-13120,14624,7932),Vector(14340,14624,7932),Vector(14340,-15208,7932),Vector(-13120,-15208,7932),Vector(-13120,14624,7932),Vector(14340,-15208,7932)],[Vector(14340,-15208,-128),Vector(14340,-15208,7932),Vector(14340,14624,7932),Vector(14340,14624,-128),Vector(14340,-15208,-128),Vector(14340,14624,7932),Vector(14340,6720,-7932),Vector(14340,6720,-1024),Vector(14340,14400,-1024),Vector(14340,14400,-1024),Vector(14340,14400,-7932),Vector(14340,6720,-7932),Vector(-9312,-15208,-1024),Vector(-9312,-15208,-3072),Vector(-12896,-15208,-3072),Vector(-12896,-15208,-3072),Vector(-12896,-15208,-1024),Vector(-9312,-15208,-1024),Vector(14340,-15208,7932),Vector(14340,-15208,-128),Vector(-13120,-15208,-128),Vector(-13120,-15208,7932),Vector(14340,-15208,7932),Vector(-13120,-15208,-128),Vector(14340,14400,-7932),Vector(7840,14400,-7932),Vector(7840,6720,-7932),Vector(7840,6720,-7932),Vector(14340,6720,-7932),Vector(14340,14400,-7932),Vector(-13120,14624,7932),Vector(14340,14624,7932),Vector(14340,-15208,7932),Vector(-13120,-15208,7932),Vector(-13120,14624,7932),Vector(14340,-15208,7932)],[Vector(92,844,168),Vector(92,988,168),Vector(92,988,-128),Vector(92,988,-128),Vector(92,844,-128),Vector(92,844,168),Vector(-164,844,168),Vector(-164,988,168),Vector(92,988,168),Vector(92,844,168),Vector(-164,844,168),Vector(92,988,168),Vector(-164,844,152),Vector(-164,844,168),Vector(92,844,168),Vector(92,844,152),Vector(-164,844,152),Vector(92,844,168),Vector(84,-468,-8),Vector(84,-596,-8),Vector(84,-588,50.25),Vector(84,-588,50.25),Vector(84,-514.625,120),Vector(84,-468,-8),Vector(84,-468,-8),Vector(84,-514.625,120),Vector(84,-468,120),Vector(-308,844,152),Vector(252,844,152),Vector(252,-468,152),Vector(252,-468,152),Vector(-308,-468,152),Vector(-308,844,152),Vector(-276,-596,-8),Vector(-276,-468,-8),Vector(400,-468,-8),Vector(400,-596,-8),Vector(-276,-596,-8),Vector(400,-468,-8),Vector(-276,-892,-8),Vector(-276,-596,-8),Vector(400,-596,-8),Vector(400,-892,-8),Vector(-276,-892,-8),Vector(400,-596,-8),Vector(84,-596,-8),Vector(84,-468,-8),Vector(-276,-468,-8),Vector(-276,-468,-8),Vector(-276,-596,-8),Vector(84,-596,-8),Vector(-276,-514.625,120),Vector(-276,-468,120),Vector(84,-468,120),Vector(84,-514.625,120),Vector(-276,-514.625,120),Vector(84,-468,120),Vector(-364,-476,-72),Vector(-364,-468,-72),Vector(-276,-468,-72),Vector(-276,-476,-72),Vector(-364,-476,-72),Vector(-276,-468,-72),Vector(-364,-476,-128),Vector(-364,-476,-72),Vector(-276,-476,-72),Vector(-276,-476,-128),Vector(-364,-476,-128),Vector(-276,-476,-72),Vector(-388,-468,-72),Vector(332,-468,-72),Vector(332,844,-72),Vector(-388,844,-72),Vector(-388,-468,-72),Vector(332,844,-72),Vector(-276,-514.625,120),Vector(-276,-588,50.25),Vector(-276,-468,120),Vector(-276,-596,-8),Vector(-276,-468,120),Vector(-276,-588,50.25),Vector(-276,-468,-128),Vector(-276,-468,120),Vector(-276,-596,-8),Vector(-276,-468,-128),Vector(-276,-596,-8),Vector(-276,-984.363647,-128),Vector(-276,-892,-8),Vector(-276,-984.363647,-128),Vector(-276,-596,-8),Vector(-276,-980,-80),Vector(-276,-984.363647,-128),Vector(-276,-892,-8),Vector(400,-596,-128),Vector(400,-596,-8),Vector(-276,-596,-8),Vector(-276,-596,-8),Vector(-276,-596,-128),Vector(400,-596,-128),Vector(-276,-596,-128),Vector(-276,-596,-8),Vector(400,-596,-8),Vector(400,-596,-128),Vector(-276,-596,-128),Vector(400,-596,-8),Vector(400,-468,-8),Vector(372.727264,-468,-8),Vector(400,-468,-128),Vector(372.727264,-468,-8),Vector(308,-468,-72),Vector(400,-468,-128),Vector(400,-468,-128),Vector(308,-468,-72),Vector(308,-468,-128),Vector(388,-468,16),Vector(332,-468,-72),Vector(252,-468,152),Vector(-388,-468,-72),Vector(252,-468,152),Vector(332,-468,-72),Vector(252,-468,152),Vector(-388,-468,-72),Vector(-308,-468,152),Vector(-388,-468,-72),Vector(-444,-468,16),Vector(-308,-468,152),Vector(-276,-980,-80),Vector(-276,-892,-8),Vector(400,-892,-8),Vector(400,-980,-80),Vector(-276,-980,-80),Vector(400,-892,-8),Vector(-276,-984.363647,-128),Vector(-276,-980,-80),Vector(400,-980,-80),Vector(400,-984.363647,-128),Vector(-276,-984.363647,-128),Vector(400,-980,-80),Vector(-276,-596,-8),Vector(-276,-588,50.25),Vector(84,-588,50.25),Vector(84,-588,50.25),Vector(84,-596,-8),Vector(-276,-596,-8),Vector(-276,-588,50.25),Vector(-276,-514.625,120),Vector(84,-514.625,120),Vector(84,-588,50.25),Vector(-276,-588,50.25),Vector(84,-514.625,120),Vector(-164,844,-128),Vector(-164,988,-128),Vector(-164,988,168),Vector(-164,988,168),Vector(-164,844,168),Vector(-164,844,-128),Vector(-308,844,152),Vector(-444,844,16),Vector(-388,844,-72),Vector(-308,844,152),Vector(-388,844,-72),Vector(332,844,-72),Vector(332,844,-72),Vector(252,844,152),Vector(-308,844,152),Vector(332,844,-72),Vector(388,844,16),Vector(252,844,152),Vector(-164,844,-128),Vector(-164,844,-72),Vector(92,844,-72),Vector(92,844,-128),Vector(-164,844,-128),Vector(92,844,-72),Vector(92,988,168),Vector(-164,988,168),Vector(-164,988,-128),Vector(-164,988,-128),Vector(92,988,-128),Vector(92,988,168),Vector(-364,820,-128),Vector(-364,820,-72),Vector(-364,-476,-72),Vector(-364,-476,-72),Vector(-364,-476,-128),Vector(-364,820,-128),Vector(308,-476,-128),Vector(308,-476,-72),Vector(308,820,-72),Vector(308,820,-128),Vector(308,-476,-128),Vector(308,820,-72),Vector(308,820,-128),Vector(308,820,-72),Vector(-364,820,-72),Vector(-364,820,-72),Vector(-364,820,-128),Vector(308,820,-128),Vector(252,844,152),Vector(388,844,16),Vector(388,-468,16),Vector(388,-468,16),Vector(252,-468,152),Vector(252,844,152),Vector(-388,844,-72),Vector(-444,844,16),Vector(-444,-468,16),Vector(-444,-468,16),Vector(-388,-468,-72),Vector(-388,844,-72),Vector(-444,844,16),Vector(-308,844,152),Vector(-308,-468,152),Vector(-444,-468,16),Vector(-444,844,16),Vector(-308,-468,152),Vector(332,-468,-72),Vector(388,-468,16),Vector(388,844,16),Vector(332,844,-72),Vector(332,-468,-72),Vector(388,844,16)],[Vector(656,-600.521667,-4),Vector(656,-368.855713,-4),Vector(704.086426,-379.308502,-4),Vector(1013.36182,1043.46509,-4),Vector(847.403503,280,-4),Vector(495.706909,280,-4),Vector(1013.36182,1043.46509,-4),Vector(495.706909,280,-4),Vector(400,300.804321,-4),Vector(400,300.804321,-4),Vector(184.713867,1223.59253,-4),Vector(1013.36182,1043.46509,-4),Vector(184.713867,1223.59253,-4),Vector(400,300.804321,-4),Vector(-308.088135,-1043.46411,-4),Vector(400,300.804321,-4),Vector(400,-1197.38501,-4),Vector(-308.088135,-1043.46411,-4),Vector(-114.365952,-152.276245,-4),Vector(-497.42041,-69,-4),Vector(-392.062744,415.671387,-4),Vector(-9,332.404785,-4),Vector(-114.365952,-152.276245,-4),Vector(-392.062744,415.671387,-4),Vector(-497.42041,-69,-4),Vector(-114.365952,-152.276245,-4),Vector(-9,332.404785,-4),Vector(-392.062744,415.671387,-4),Vector(-497.42041,-69,-4),Vector(-9,332.404785,-4),Vector(495.70694,280,172),Vector(400,280,172),Vector(104.513428,365.035767,172),Vector(-22.9353046,-221.272034,172),Vector(104.513428,365.035767,172),Vector(400,280,172),Vector(400,280,172),Vector(400,-313.207672,172),Vector(-22.9353046,-221.272034,172),Vector(704.086426,-379.308502,172),Vector(656,-368.855713,172),Vector(656,24,172),Vector(791.755676,24,172),Vector(704.086426,-379.308502,172),Vector(656,24,172),Vector(-1013.37134,43.1452026,60),Vector(-908.013672,527.826294,60),Vector(92.6181641,310.313721,60),Vector(92.6181641,310.313721,60),Vector(-12.739501,-174.367371,60),Vector(-1013.37134,43.1452026,60),Vector(-497.42041,-69,-76),Vector(-392.062744,415.671387,-76),Vector(-908.013672,527.826294,-76),Vector(-908.013672,527.826294,-76),Vector(-1013.37134,43.1452026,-76),Vector(-497.42041,-69,-76),Vector(-308.088135,-1043.46411,-128),Vector(-308.088135,-1043.46411,-4),Vector(400,-1197.38501,-4),Vector(400,-1197.38501,-128),Vector(-308.088135,-1043.46411,-128),Vector(400,-1197.38501,-4),Vector(184.713867,1223.59253,-128),Vector(184.713867,1223.59253,-4),Vector(-308.088135,-1043.46411,-4),Vector(-308.088135,-1043.46411,-4),Vector(-308.088135,-1043.46411,-128),Vector(184.713867,1223.59253,-128),Vector(656,-600.521667,-128),Vector(656,-600.521667,-4),Vector(791.755615,24,-4),Vector(791.755493,24,-128),Vector(656,-600.521667,-128),Vector(791.755615,24,-4),Vector(1013.36182,1043.46509,-4),Vector(1013.36182,1043.46509,-128),Vector(847.403503,280,-128),Vector(847.403503,280,-128),Vector(847.403503,280,-4),Vector(1013.36182,1043.46509,-4),Vector(184.713867,1223.59253,-4),Vector(184.713867,1223.59253,-128),Vector(1013.36182,1043.46509,-128),Vector(1013.36182,1043.46509,-128),Vector(1013.36182,1043.46509,-4),Vector(184.713867,1223.59253,-4),Vector(104.513428,365.035767,-4),Vector(104.513428,365.035767,172),Vector(-22.9353046,-221.272034,172),Vector(-22.9353046,-221.272034,172),Vector(-22.9353046,-221.272034,-4),Vector(104.513428,365.035767,-4),Vector(656,-368.855713,172),Vector(704.086426,-379.308502,172),Vector(704.086426,-379.308502,-4),Vector(704.086426,-379.308502,-4),Vector(656,-368.855713,-4),Vector(656,-368.855713,172),Vector(-22.9353046,-221.272034,-4),Vector(-22.9353046,-221.272034,172),Vector(400,-313.207672,172),Vector(400,-313.207672,-4),Vector(-22.9353046,-221.272034,-4),Vector(400,-313.207672,172),Vector(104.513428,365.035767,172),Vector(104.513428,365.035767,-4),Vector(495.706909,280,-4),Vector(495.70694,280,172),Vector(104.513428,365.035767,172),Vector(495.706909,280,-4),Vector(704.086426,-379.308502,-4),Vector(704.086426,-379.308502,172),Vector(791.755676,24,172),Vector(791.755615,24,-4),Vector(704.086426,-379.308502,-4),Vector(791.755676,24,172),Vector(-497.42041,-69,-128),Vector(-497.42041,-69,-4),Vector(-114.365952,-152.276245,-4),Vector(-114.365959,-152.276245,-128),Vector(-497.42041,-69,-128),Vector(-114.365952,-152.276245,-4),Vector(-392.062744,415.671387,-128),Vector(-392.062744,415.671387,-4),Vector(-497.42041,-69,-4),Vector(-497.42041,-69,-4),Vector(-497.42041,-69,-128),Vector(-392.062744,415.671387,-128),Vector(-9,332.404785,-128),Vector(-9,332.404785,-4),Vector(-392.062744,415.671387,-4),Vector(-392.062744,415.671387,-4),Vector(-392.062744,415.671387,-128),Vector(-9,332.404785,-128),Vector(-392.062744,415.671387,-4),Vector(-392.062744,415.671387,32),Vector(-497.42041,-69,32),Vector(-497.42041,-69,32),Vector(-497.42041,-69,-4),Vector(-392.062744,415.671387,-4),Vector(-497.42041,-69,-4),Vector(-497.42041,-69,60),Vector(-12.739501,-174.367371,60),Vector(-12.739501,-174.367371,-4),Vector(-497.42041,-69,-4),Vector(-12.739501,-174.367371,60),Vector(-392.062744,415.671387,60),Vector(-392.062744,415.671387,-4),Vector(92.6181641,310.313721,-4),Vector(92.6181641,310.313721,60),Vector(-392.062744,415.671387,60),Vector(92.6181641,310.313721,-4),Vector(-12.739501,-174.367371,-4),Vector(-12.739501,-174.367371,32),Vector(92.6181641,310.313721,32),Vector(92.6181641,310.313721,-4),Vector(-12.739501,-174.367371,-4),Vector(92.6181641,310.313721,32),Vector(-1013.37134,43.1452026,-76),Vector(-1013.37134,43.1452026,60),Vector(-497.42041,-69,60),Vector(-497.42041,-69,-76),Vector(-1013.37134,43.1452026,-76),Vector(-497.42041,-69,60),Vector(-908.013672,527.826294,-76),Vector(-908.013672,527.826294,60),Vector(-1013.37134,43.1452026,60),Vector(-1013.37134,43.1452026,-76),Vector(-908.013672,527.826294,-76),Vector(-1013.37134,43.1452026,60),Vector(-908.013672,527.826294,60),Vector(-908.013672,527.826294,-76),Vector(-392.062744,415.671387,-76),Vector(-392.062744,415.671387,60),Vector(-908.013672,527.826294,60),Vector(-392.062744,415.671387,-76)]]
 array<vector> birds = [Vector(-3035.52,3752.8,382.733),Vector(3357.81,2281.92,1764.72),Vector(-1131.11,2904.34,1324.47),Vector(2172.48,2372.72,785.032),Vector(1731.86,7508.48,964.341),Vector(2736.85,2861.1,1922.74),Vector(610.356,557.52,1696.73),Vector(-846.564,-1417.28,926.975),Vector(-5660.96,-1895.54,490.724),Vector(-5673.95,-1925.33,480.477),Vector(-7891,2038.04,400.022),Vector(2416.47,5783.28,1719.06),Vector(-7775.81,3430.09,584.223),Vector(225.161,9068.04,1780.32),Vector(-1793.1,3802.01,506.662),Vector(-9100.02,3744.54,465.465),Vector(-6383.71,6003.02,562.812),Vector(-6465.36,5426.35,511.648),Vector(-2093.81,5715.86,441.881),Vector(-5600.8,5974.51,453.229),Vector(-5525.79,7357.6,473.941),Vector(-2437.97,-2633.1,769.62),Vector(281.826,3268.93,1359.22),Vector(-3016.26,4431.67,369.604),Vector(-2442.54,5457.77,451.383),Vector(-2916.38,3661.74,298.271)]
}
file

void function LagoonNativeAudio_Init()
{
#if TF1AudioRuntime
 return
#endif
 if (GetMapName() != "mp_tf1_lagoon") return
 if (file.started) return
 file.started = true
 file.stopped = false
 thread LagoonNativeAudio_Run()
 thread LagoonNativeAudio_Birds()
}

void function LagoonNativeAudio_Birds()
{
 float nextPlay = Time() + RandomFloatRange(7.0, 12.0)
 while (!file.stopped)
 {
  entity player = GetLocalViewPlayer()
  if (IsValid(player))
  {
   int nearest = -1
   float best = 3000.0
   foreach (int i, vector position in file.birds)
   {
    float distance = Distance(player.EyePosition(), position)
    if (distance < best)
    {
     best = distance
     nearest = i
    }
   }
   if (nearest >= 0 && Time() >= nextPlay)
   {
    EmitSoundAtPosition(player.GetTeam(), file.birds[nearest], "amb_swampland_emitter_birdflock")
    nextPlay = Time() + RandomFloatRange(7.0, 12.0)
    printt("LAGOON_NATIVE_BIRDS", nearest)
   }
  }
  wait 0.25
 }
}

void function LagoonNativeAudio_Shutdown()
{
 file.stopped = true
 LagoonNativeAudio_Stop()
}

void function LagoonNativeAudio_Stop()
{
 if (IsValid(file.listener) && file.current >= 0)
  StopSoundOnEntity(file.listener, file.events[file.current])
 file.current = -1
 file.listener = null
}

bool function LagoonNativeAudio_Contains(int i, vector point)
{
 vector p = point - file.origins[i]
 vector lo = file.mins[i]
 vector hi = file.maxs[i]
 if (p.x < lo.x || p.y < lo.y || p.z < lo.z || p.x > hi.x || p.y > hi.y || p.z > hi.z)
  return false
 vector ray = Vector(1.0, 0.1234567, 0.271828)
 array<float> hits
 array<vector> faces = file.triangles[i]
 for (int n = 0; n < faces.len(); n += 3)
 {
  vector a = faces[n]
  vector e1 = faces[n+1] - a
  vector e2 = faces[n+2] - a
  vector h = CrossProduct(ray, e2)
  float d = DotProduct(e1, h)
  if (fabs(d) < 0.0000001) continue
  vector s = p - a
  float u = DotProduct(s, h) / d
  if (u < 0.0 || u > 1.0) continue
  vector q = CrossProduct(s, e1)
  float v = DotProduct(ray, q) / d
  if (v < 0.0 || u+v > 1.0) continue
  float at = DotProduct(e2, q) / d
  if (at <= 0.00001) continue
  bool duplicate = false
  foreach (float previous in hits)
   if (fabs(previous-at) <= 0.001) duplicate = true
  if (!duplicate) hits.append(at)
 }
 return hits.len() % 2 == 1
}

void function LagoonNativeAudio_Run()
{
 printt("LAGOON_NATIVE_AUDIO_READY", file.regionEvents.len())
 while (!file.stopped)
 {
  entity player = GetLocalViewPlayer()
  if (!IsValid(player))
  {
   LagoonNativeAudio_Stop()
   wait 0.1
   continue
  }
  int selected = 0
  float smallest = 1.0e30
  foreach (int i, int event in file.regionEvents)
  {
   if (!LagoonNativeAudio_Contains(i, player.EyePosition())) continue
   vector span = file.maxs[i] - file.mins[i]
   float size = span.x * span.y * span.z
   if (size < smallest)
   {
    smallest = size
    selected = event
   }
  }
  if (file.listener != player || selected != file.current)
  {
   LagoonNativeAudio_Stop()
   file.listener = player
   file.current = selected
   EmitSoundOnEntity(player, file.events[selected])
   printt("LAGOON_NATIVE_REGION", selected, file.events[selected])
  }
  wait 0.1
 }
}
