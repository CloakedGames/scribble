/// Adds a normal font for use with Scribble.
///
/// @param fontName   String name of the font to add
/// @param [yyPath]   File path for the font's .yy file, including the .yy extension, relative to the font directory defined by scribble_init().
///                   If not specified, Scribble will look in the root of the font directory
/// @param [texture]  Texture
///
/// Scribble requires all standard fonts to have their .yy file added as an included file
/// This means every time you modify a font you also need to update the included .yy file
/// (Including .yy files isn't necessary for spritefonts)

if (!variable_global_exists("__scribble_default_font"))
{
    show_error("Scribble:\nscribble_add_font() should be called after scribble_init()\n ", true);
    return undefined;
}
    
var _font    = argument[0];
var _yy_path = (argument_count > 1)? argument[1] : (_font + ".yy");
var _texture = (argument_count > 2)? argument[2] : undefined;
_yy_path = global.__scribble_font_directory + _yy_path;
    
if (ds_map_exists(global.__scribble_font_data, _font))
{
	show_error("Scribble:\nFont \"" + _font + "\" has already been defined\n ", false);
	return undefined;
}
    
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Processing font \"" + _font + "\"");
    
if (_texture == undefined)
{
    if (!is_string(_font))
    {
        show_error("Scribble:\n<character> argument is the wrong datatype (" + typeof(_font) + "), expected a string\n ", false);
        return undefined;
    }
    
    if (asset_get_type(_font) == asset_sprite)
    {
        show_error("Scribble:\nAsset \"" + _font + "\" is a sprite\n \nPlease use scribble_add_spritefont() instead\n ", false);
        return undefined;
    }
    
    if (asset_get_type(_font) != asset_font)
    {
        show_error("Scribble:\nSCRIBBLE_ERROR_ASSET_DOES_NOT_EXIST\n \nCould not find font asset \"" + _font + "\" in the project\n ", false);
        return undefined;
    }
        
    if (!file_exists(_yy_path))
    {
        if (global.__scribble_autoscanning)
        {
            if (SCRIBBLE_WARNING_AUTOSCAN_YY_NOT_FOUND)
            {
                show_error("Scribble:\nCould not find \"" + _yy_path + "\" in Included Files\nSet SCRIBBLE_WARNING_AUTOSCAN_MISSING_YY to <false> to ignore this warning\n ", false);
                return undefined;
            }
            else
            {
                show_debug_message("Scribble: Warning! Could not find \"" + _yy_path + "\" in Included Files");
            }
                
            return undefined;
        }
        else
        {
            show_error("Scribble:\n\nCould not find \"" + _yy_path + "\" in Included Files\n ", false);
            return undefined;
        }
    }
        
    var _asset       = asset_get_index(_font);
    var _texture     = font_get_texture(_asset);
    var _texture_uvs = font_get_uvs(_asset);
}
else
{
    var _texture_uvs = texture_get_uvs(_texture);
}
    
var _texture_tw = texture_get_texel_width(_texture);
var _texture_th = texture_get_texel_height(_texture);
var _texture_w  = (_texture_uvs[2] - _texture_uvs[0])/_texture_tw; //texture_get_width(_texture);
var _texture_h  = (_texture_uvs[3] - _texture_uvs[1])/_texture_th; //texture_get_height(_texture);
    
    
    
var _data = array_create(__SCRIBBLE_FONT.__SIZE);
_data[@ __SCRIBBLE_FONT.NAME        ] = _font;
_data[@ __SCRIBBLE_FONT.PATH        ] = _yy_path;
_data[@ __SCRIBBLE_FONT.TYPE        ] = __SCRIBBLE_FONT_TYPE.FONT;
_data[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPH_MIN   ] = 32;
_data[@ __SCRIBBLE_FONT.GLYPH_MAX   ] = 32;
_data[@ __SCRIBBLE_FONT.TEXTURE     ] = undefined;
_data[@ __SCRIBBLE_FONT.SPACE_WIDTH ] = undefined;
_data[@ __SCRIBBLE_FONT.MAPSTRING   ] = undefined;
_data[@ __SCRIBBLE_FONT.SEPARATION  ] = undefined;
_data[@ __SCRIBBLE_FONT.TEXTURE     ] = _texture;
global.__scribble_font_data[? _font ] = _data;
    
    
    
if (SCRIBBLE_VERBOSE)
{
	show_debug_message("Scribble:   \"" + _font +"\""
	                    + ", asset = " + string(_asset)
	                    + ", texture = " + string(_texture)
	                    + ", size = " + string(_texture_w) + " x " + string(_texture_h)
	                    + ", texel = " + string_format(_texture_tw, 1, 10) + " x " + string_format(_texture_th, 1, 10)
	                    + ", uvs = " + string_format(_texture_uvs[0], 1, 10) + "," + string_format(_texture_uvs[1], 1, 10)
	                    + " -> " + string_format(_texture_uvs[2], 1, 10) + "," + string_format(_texture_uvs[3], 1, 10));
}
    
var _json_buffer = buffer_load(_yy_path);
var _json_string = buffer_read(_json_buffer, buffer_text);
buffer_delete(_json_buffer);
var _json = json_decode(_json_string);
    
var _fail = false;
//Check to see if the JSON was successfully decoded
if (_json < 0)
{
	show_error("Scribble:\nFailed to decode JSON for \"" + _yy_path + "\"\n ", false);
	_fail = true;
}
    
//Additional check to verify we have glyph data
if (!ds_map_exists(_json, "glyphs"))
{
	show_error("Scribble:\nFailed to find \"glyphs\" key for \"" + _yy_path + "\"\n ", false);
	_fail = true;
}
    
//If either of the checks have failed, delete the data array and abort
if (_fail)
{
	if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: JSON string that failed is \"" + string(_json_string) + "\"");
	ds_map_delete(global.__scribble_font_data, _font);
	exit;
}
    
    
var _yy_glyph_list = _json[? "glyphs" ];
var _size = ds_list_size(_yy_glyph_list);
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   \"" + _font + "\" has " + string(_size) + " characters");
    
    
    
var _ds_map_fallback = true;
    
if (SCRIBBLE_SEQUENTIAL_GLYPH_TRY)
{
    #region Sequential glyph index
        
	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Trying sequential glyph index...");
        
	var _glyph_map = ds_map_create();
        
	var _yy_glyph_map = _yy_glyph_list[| 0];
	    _yy_glyph_map = _yy_glyph_map[? "Value"];
        
	var _glyph_min = _yy_glyph_map[? "character"];
	var _glyph_max = _glyph_min;
	_glyph_map[? _glyph_min ] = 0;
        
	for(var _i = 1; _i < _size; _i++)
	{
	    var _yy_glyph_map = _yy_glyph_list[| _i];
	        _yy_glyph_map = _yy_glyph_map[? "Value"];
	    var _index = _yy_glyph_map[? "character"];
            
	    _glyph_map[? _index] = _i;
	    _glyph_min = min(_glyph_min, _index);
	    _glyph_max = max(_glyph_max, _index);
	}
        
	_data[@ __SCRIBBLE_FONT.GLYPH_MIN] = _glyph_min;
	_data[@ __SCRIBBLE_FONT.GLYPH_MAX] = _glyph_max;
        
	var _glyph_count = 1 + _glyph_max - _glyph_min;
	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Glyphs start at " + string(_glyph_min) + " and end at " + string(_glyph_max) + ". Range is " + string(_glyph_count-1));
        
	if ((_glyph_count-1) > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE)
	{
	    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Glyph range exceeds maximum (" + string(SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE) + ")!");
	}
	else
	{
	    var _holes = 0;
	    for(var _i = _glyph_min; _i <= _glyph_max; _i++) if (!ds_map_exists(_glyph_map, _i)) _holes++;
	    ds_map_destroy(_glyph_map);
	    var _fraction = _holes / _glyph_count;
            
	    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   There are " + string(_holes) + " holes, " + string(_fraction*100) + "%");
            
	    if (_fraction > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES)
	    {
	        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Hole proportion exceeds maximum (" + string(SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES*100) + "%)!");
	    }
	    else
	    {
	        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Using an array to index glyphs");
	        _ds_map_fallback = false;
                
	        var _font_glyphs_array = array_create(_glyph_count, undefined);
	        _data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = _font_glyphs_array;
                
	        for(var _i = 0; _i < _size; _i++)
	        {
	            var _yy_glyph_map = _yy_glyph_list[| _i];
	                _yy_glyph_map = _yy_glyph_map[? "Value"];
                    
	            var _index = _yy_glyph_map[? "character"];
	            var _char  = chr(_index);
	            var _x     = _yy_glyph_map[? "x"];
	            var _y     = _yy_glyph_map[? "y"];
	            var _w     = _yy_glyph_map[? "w"];
	            var _h     = _yy_glyph_map[? "h"];
                    
	            var _u0    = _x*_texture_tw + _texture_uvs[0];
	            var _v0    = _y*_texture_th + _texture_uvs[1];
	            var _u1    = _u0 + _w * _texture_tw;
	            var _v1    = _v0 + _h * _texture_th;
                    
	            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
	            _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
	            _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
	            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
	            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
	            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _yy_glyph_map[? "offset"];
	            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
	            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _yy_glyph_map[? "shift"];
	            _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
	            _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
	            _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
	            _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
                    
	            _font_glyphs_array[@ _index - _glyph_min] = _array;
	        }
	    }
	}
        
    #endregion
}
    
if (_ds_map_fallback)
{
	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   Using a ds_map to index glyphs");
        
	var _font_glyphs_map = ds_map_create();
	_data[@ __SCRIBBLE_FONT.GLYPHS_MAP] = _font_glyphs_map;
        
	for(var _i = 0; _i < _size; _i++)
	{
	    var _yy_glyph_map = _yy_glyph_list[| _i];
	        _yy_glyph_map = _yy_glyph_map[? "Value"];
            
	    var _index = _yy_glyph_map[? "character"];
	    var _char  = chr(_index);
	    var _x     = _yy_glyph_map[? "x"];
	    var _y     = _yy_glyph_map[? "y"];
	    var _w     = _yy_glyph_map[? "w"];
	    var _h     = _yy_glyph_map[? "h"];
            
	    var _u0    = _x*_texture_tw + _texture_uvs[0];
	    var _v0    = _y*_texture_th + _texture_uvs[1];
	    var _u1    = _u0 + _w*_texture_tw;
	    var _v1    = _v0 + _h*_texture_th;
            
	    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
	    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
	    _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
	    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
	    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
	    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _yy_glyph_map[? "offset"];
	    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
	    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _yy_glyph_map[? "shift"];
	    _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
	    _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
	    _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
	    _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
            
	    _font_glyphs_map[? ord(_char)] = _array;
	}
}
    
ds_map_destroy(_json);
    
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added \"" + _font + "\" as a standard font");