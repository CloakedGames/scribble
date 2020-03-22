/// @param textElement
/// @param speed
/// @param smoothness
/// @param perLine

var _scribble_array = argument0;
var _speed          = argument1;
var _smoothness     = argument2;
var _per_line       = argument3;

//Check if this array is a relevant text element
if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_tw_fade_out() is not a valid Scribble text element.");
    exit;
}

if (_scribble_array[__SCRIBBLE.FREED]) exit;

//Update the remaining typewriter state values
_scribble_array[@ __SCRIBBLE.TW_POSITION  ] = 0;
_scribble_array[@ __SCRIBBLE.TW_METHOD    ] = _per_line? SCRIBBLE_TW_PER_LINE : SCRIBBLE_TW_PER_CHARACTER;
_scribble_array[@ __SCRIBBLE.TW_SPEED     ] = _speed;
_scribble_array[@ __SCRIBBLE.TW_SMOOTHNESS] = _smoothness;
_scribble_array[@ __SCRIBBLE.TW_FADE_IN   ] = false;