/// @param element
/// @param sound{array}
/// @param overlap{ms}
/// @param minPitch
/// @param maxPitch
/// @param [occuranceID]

var _element   = argument[0];
var _sound     = argument[1];
var _overlap   = argument[2];
var _min_pitch = argument[3];
var _max_pitch = argument[4];
var _occurance = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

if (!is_array(_sound)) _sound = [_sound];

var _occurance_array = scribble_occurance(_element, _occurance);
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_ARRAY    ] = _sound;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_OVERLAP  ] = _overlap;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_MIN_PITCH] = _min_pitch;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_MAX_PITCH] = _max_pitch;