/// @param element
/// @param sound{array}
/// @param overlap{ms}
/// @param minPitch
/// @param maxPitch

var _element   = argument0;
var _sound     = argument1;
var _overlap   = argument2;
var _min_pitch = argument3;
var _max_pitch = argument4;

if (!is_array(_sound)) _sound = [_sound];
_element[@ __SCRIBBLE.TW_SOUND_ARRAY    ] = _sound;
_element[@ __SCRIBBLE.TW_SOUND_OVERLAP  ] = _overlap;
_element[@ __SCRIBBLE.TW_SOUND_MIN_PITCH] = _min_pitch;
_element[@ __SCRIBBLE.TW_SOUND_MAX_PITCH] = _max_pitch;