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

var _sound = asset_get_index(_event_data[0]);
if (audio_exists(_sound))
{
    audio_play_sound(_sound, 1, false);
}
else
{
    show_debug_message("Sound \"" + string(_event_data[0]) + "\" doesn't exist!");
}