/// Returns: The text element's typewriter state (see below)
/// @param textElement   A text element returned by scribble_draw()
/// @param [occuranceID]
/// 
/// The typewriter state is a real value as follows:
///     state < 0   Typewriter not set
///     state = 0   Not yet faded in, invisible
/// 0 < state < 1   Fading in
///     state = 1   Fully visible
/// 1 < state < 2   Fading out
///     state = 2   Fully faded out, invisible

var _element   = argument[0];
var _occurance = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

//Check if this array is a relevant text element
if (!is_array(_element)
|| (array_length_1d(_element) != __SCRIBBLE.__SIZE)
|| (_element[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_tw_get() is not a valid Scribble text element.");
    exit;
}

if (_element[__SCRIBBLE.FREED]) return 0;

var _occurance_array = scribble_occurance(_element, _occurance);

//Early out if the method is NONE
var _typewriter_method = _occurance_array[__SCRIBBLE_OCCURANCE.TW_METHOD];
if (_typewriter_method == SCRIBBLE_TW_NONE) return 1;

//Return an error code if the fade in state has not been set
//(The fade in state is initialised as -1)
var _typewriter_fade_in = _occurance_array[__SCRIBBLE_OCCURANCE.TW_FADE_IN];
if (_occurance_array[__SCRIBBLE_OCCURANCE.TW_FADE_IN] < 0) return -2;

var _element_pages_array = _element[__SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];

switch(_typewriter_method)
{
    case SCRIBBLE_TW_PER_CHARACTER: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
    case SCRIBBLE_TW_PER_LINE:      var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
}

//Normalise the parameter from 0 -> 1 using the total counter
var _typewriter_t = clamp(_occurance_array[__SCRIBBLE_OCCURANCE.TW_POSITION]/_typewriter_count, 0, 1);

//Add one if we're fading out
return _typewriter_fade_in? _typewriter_t : (_typewriter_t+1);