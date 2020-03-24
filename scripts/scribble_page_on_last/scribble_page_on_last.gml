/// @param element
/// @param [occuranceID]

var _element   = argument[0];
var _occurance = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_OCCURANCE_ID;

var _occurance_array = scribble_occurance(_element, _occurance);
return (_occurance_array[__SCRIBBLE_OCCURANCE.PAGE] >= (_element[__SCRIBBLE.PAGES]-1));