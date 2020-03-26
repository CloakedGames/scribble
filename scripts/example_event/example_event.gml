/// An example event called by Scribble's typewriter feature
/// 
/// @param   textElement
/// @param   occuranceID
/// @param   eventData{array}
/// @param   characterIndex

var _text_element = argument0;
var _occurance_id = argument1;
var _event_data   = argument2;
var _char_index   = argument3;

show_debug_message("Text element called event script \"example_event\" at character=" + string(_char_index) + ", data=" + string(_event_data));