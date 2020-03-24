/// @param textElement
/// @param speed
/// @param smoothness
/// @param perLine
/// @param [occuranceID]

var _element    = argument[0];
var _speed      = argument[1];
var _smoothness = argument[2];
var _per_line   = argument[3];
var _occurance  = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

//Check if this array is a relevant text element
if (!is_array(_element)
|| (array_length_1d(_element) != __SCRIBBLE.__SIZE)
|| (_element[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_tw_fade_in() is not a valid Scribble text element.");
    exit;
}

if (_element[__SCRIBBLE.FREED]) exit;

var _occurance_array = scribble_occurance(_element, _occurance);

//Update the remaining typewriter state values
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_POSITION  ] = 0;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_METHOD    ] = _per_line? SCRIBBLE_TW_PER_LINE : SCRIBBLE_TW_PER_CHARACTER;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SPEED     ] = _speed;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SMOOTHNESS] = _smoothness;
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_FADE_IN   ] = true;

//Reset this page's previous event position too
_occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_PREVIOUS     ] = -1;
_occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS] = -1;