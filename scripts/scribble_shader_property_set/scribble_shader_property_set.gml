///  0  "wave_size"        : 
///  1  "wave_frequency"   : 
///  2  "wave_speed"       : 
///  3  "shake_size"       : 
///  4  "shake_speed"      : 
///  5  "rainbow_weight"   : 
///  6  "rainbow_speed"    : 
///  7  "wobble_angle"     : 
///  8  "wobble_frequency" : 
///  9  "pulse_scale"      : 
/// 10  "pulse_speed"      : 
/// 
/// @param propertyName
/// @param value
/// @param [relative]

var _name     = argument[0];
var _value    = argument[1];
var _relative = (argument_count > 2)? argument[2] : false;

var _index = global.__scribble_animation_property_map[? _name];
if (_index == undefined)
{
    show_error("Scribble:\nProperty \"" + string(_name) + "\" not recognised\n ", false);
    exit;
}

if (_relative) _value += global.__scribble_animation_value_array[_index];
global.__scribble_animation_value_array[@ _index] = _value;