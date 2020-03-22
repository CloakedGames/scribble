/// @param propertyName

var _name = argument0;

var _index = global.__scribble_animation_property_map[? _name];
if (_index == undefined) return undefined;

return global.__scribble_animation_value_array[_index];