/// @param propertyName
/// @param uniformIndex
/// @param defaultValue

var _name    = argument0;
var _index   = argument1;
var _default = argument2;

if (!variable_global_exists("__scribble_default_font")) show_error("Scribble:\nScribble has not been initialized\nRun scribble_init() before using other Scribble functions\n ", false);

if (!is_string(_name)) show_error("Scribble:\n \n<propertyName> argument is the wrong datatype (" + typeof(_name) + "), expected a string\n ", false);

if (!is_real( _index)
&&  !is_int32(_index)
&&  !is_int64(_index)
&&  !is_bool( _index))
{
    show_error("Scribble:\n<uniformIndex> argument is the wrong datatype (" + typeof(_index) + "), expected a number\n ", false);
}

_index = floor(_index);

if ((_index < 0) || (_index >= SCRIBBLE_SHADER_MAX_PROPERTIES))
{
    show_error("Scribble:\n<uniformIndex> should be between 0 and " + string(SCRIBBLE_SHADER_MAX_PROPERTIES-1) + " inclusive (was " + string(_index) + ")\nSet SCRIBBLE_SHADER_MAX_PROPERTIES to a larger number to increase this range\n ", false);
}

if (!is_real( _default)
&&  !is_int32(_default)
&&  !is_int64(_default)
&&  !is_bool( _default))
{
    show_error("Scribble:\n<defaultValue> argument is the wrong datatype (" + typeof(_default) + "), expected a number\n ", false);
}

global.__scribble_shader_property_map[?             _name] = _index;
global.__scribble_shader_property_array[@          _index] = _name;
global.__scribble_shader_property_value_array[@    _index] = _default;
global.__scribble_shader_property_default_array[@  _index] = _default;