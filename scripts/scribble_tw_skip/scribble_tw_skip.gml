/// @param textElement
/// @param [occuranceID]

var _element   = argument[0];
var _occurance = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

//Check if this array is a relevant text element
if (!is_array(_element)
|| (array_length_1d(_element) != __SCRIBBLE.__SIZE)
|| (_element[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Array passed to scribble_tw_skip() is not a valid Scribble text element.");
    exit;
}

if (_element[__SCRIBBLE.FREED]) exit;

var _occurance_array = scribble_occurance(_element, _occurance);
var _element_pages_array = _element[__SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];

var _max = 1;
switch(_occurance_array[__SCRIBBLE_OCCURANCE.TW_METHOD])
{
    case SCRIBBLE_TW_PER_CHARACTER: var _max = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
    case SCRIBBLE_TW_PER_LINE:      var _max = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
}

_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_POSITION] = _max + _occurance_array[__SCRIBBLE_OCCURANCE.TW_SMOOTHNESS];

return _max;