/// @param element
/// @param page
/// @param [occuranceID]

var _element   = argument[0];
var _page      = argument[1];
var _occurance = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

_page = clamp(_page, 0, _element[__SCRIBBLE.PAGES]-1);

var _occurance_array = scribble_occurance(_element, _occurance);
_occurance_array[@ __SCRIBBLE_OCCURANCE.PAGE] = _page;

return _page;