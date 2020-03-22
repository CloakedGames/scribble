/// Adds a custom color for use as an in-line color definition for scribble_draw().
/// 
/// 
/// @param name                    String name of the color
/// @param color                   The color itself as a 24-bit integer
/// @param [colorIsGameMakerBGR]   Whether the color is in GameMaker's propriatery 24-bit BGR color format. Defaults to <false>.
/// 
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _name   = argument[0];
var _color  = argument[1];
var _native = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;

if ( !variable_global_exists("__scribble_default_font") )
{
    show_error("Scribble:\nscribble_add_color() should be called after initialising Scribble.\n ", false);
    exit;
}

if ( !is_string(_name) )
{
    show_error("Scribble:\nCustom color names should be strings.\n ", false);
    exit;
}

if ( !is_real(_color) )
{
    show_error("Scribble:\nCustom colors should be specificed as 24-bit integers.\n ", false);
    exit;
}

if (!_native)
{
    _color = make_color_rgb(color_get_blue(_color), color_get_green(_color), color_get_red(_color));
}

if ( ds_map_exists(global.__scribble_effects, _name) )
{
    show_debug_message("Scribble: WARNING! Color name \"" + _name + "\" has already been defined as an effect" );
    exit;
}

var _old_color = global.__scribble_colors[? _name];
if (is_real(_old_color))
{
    show_debug_message("Scribble: WARNING! Overwriting color \"" + _name + "\" (" + string(color_get_red(_old_color)) + "," + string(color_get_green(_old_color)) + "," + string(color_get_blue(_old_color)) + ", u32=" + string(_old_color) + ")");
}

global.__scribble_colors[? _name] = _color;

if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added color \"" + _name + "\" as " + string(color_get_red(_color)) + "," + string(color_get_green(_color)) + "," + string(color_get_blue(_color)) + ", u32=" + string(_color));