/// @param destinationFontName
/// @param sourceFontName
/// @param preferSource

var _dst_font      = argument0;
var _src_font      = argument1;
var _prefer_source = argument2;

var _dst_font_array = global.__scribble_font_data[? _dst_font];
var _src_font_array = global.__scribble_font_data[? _src_font];



//Work out if the destination uses an array, and if so, convert that to a map
var _dst_glyphs_map = _dst_font_array[__SCRIBBLE_FONT.GLYPHS_MAP];
if (_dst_glyphs_map == undefined)
{
    var _dst_glyphs_array = _dst_font_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
    var _dst_glyphs_min   = _dst_font_array[__SCRIBBLE_FONT.GLYPH_MIN   ];
    var _dst_glyphs_map = ds_map_create();
    _dst_font_array[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = _dst_glyphs_map;
    _dst_font_array[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
    
    var _i = 0;
    repeat(array_length_1d(_dst_glyphs_array))
    {
        var _array = _dst_glyphs_array[_i];
        if (is_array(_array)) _dst_glyphs_map[? _i + _dst_glyphs_min] = _array;
        ++_i;
    }
}



//Unpack source glyphs into an intermediate array
var _src_glyphs_map = _src_font_array[__SCRIBBLE_FONT.GLYPHS_MAP];
if (_src_glyphs_map != undefined)
{
    var _src_glyphs_array = array_create(ds_map_size(_src_glyphs_map));
    
    var _i = 0;
    var _key = ds_map_find_first(_src_glyphs_map);
    repeat(ds_map_size(_src_glyphs_map))
    {
        _src_glyphs_array[@ _i] = _src_glyphs_map[? _key];
        ++_i;
        _key = ds_map_find_next(_src_glyphs_map, _key);
    }
}
else
{
    var _src_glyphs_array = _src_font_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
}



//Copy across glyph data from the source
var _i = 0;
repeat(array_length_1d(_src_glyphs_array))
{
    var _src_glyph_array = _src_glyphs_array[_i];
    
    if (is_array(_src_glyph_array))
    {
        var _ord = _src_glyph_array[SCRIBBLE_GLYPH.INDEX];
        if (!ds_map_exists(_dst_glyphs_map, _ord) || _prefer_source)
        {
            var _new_glyph_array = array_create(SCRIBBLE_GLYPH.__SIZE);
            array_copy(_new_glyph_array, 0, _src_glyph_array, 0, SCRIBBLE_GLYPH.__SIZE);
             _dst_glyphs_map[? _ord] = _new_glyph_array;
        }
    }
    
    ++_i;
}