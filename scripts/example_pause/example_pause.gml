/// An example event called by Scribble's typewriter feature
/// 
/// @param   textElement
/// @param   occurance
/// @param   eventData{array}
/// @param   characterIndex

var _text_element = argument0;
var _occurance    = argument1;
var _event_data   = argument2;
var _char_index   = argument3;

var _occurance_array = scribble_occurance(_text_element, _occurance, false);
_occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SPEED] = 0;