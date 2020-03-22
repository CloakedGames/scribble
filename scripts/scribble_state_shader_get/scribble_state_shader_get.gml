/// @param propertyName

var _name = argument0;

var _index = global.__scribble_shader_property_map[? _name];
if (_index == undefined) return undefined;

return global.__scribble_shader_property_value_array[_index];