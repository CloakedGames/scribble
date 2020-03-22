/// @param sourceFontName
/// @param newFontName

var _source_font_name = argument0;
var _new_font_name    = argument1;

var _outline_color = c_black;
var _outline_size = 1;
var _padding      = 2;

var _texture_page_size = 512;

if (_source_font_name == _new_font_name)
{
    show_error("Scribble:\nSource font and new font cannot share the same name\n ", false);
    return undefined;
}

var _src_array = global.__scribble_font_data[? _source_font_name];
var _src_glyphs_map = _src_array[__SCRIBBLE_FONT.GLYPHS_MAP];
if (_src_glyphs_map != undefined)
{
    var _uses_glyph_map = true;
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
    var _uses_glyph_map = false;
    var _src_glyphs_array = _src_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
}

var _priority_queue = ds_priority_create();

var _i = 0;
repeat(array_length_1d(_src_glyphs_array))
{
    var _glyph_array = _src_glyphs_array[_i];
    if (_glyph_array != undefined)
    {
        var _character   = _glyph_array[SCRIBBLE_GLYPH.CHARACTER];
        if (_character != " ")
        {
            var _width       = _glyph_array[SCRIBBLE_GLYPH.WIDTH    ];
            var _height      = _glyph_array[SCRIBBLE_GLYPH.HEIGHT   ];
        
            var _width_ext  = _width  + _padding + 2*_outline_size;
            var _height_ext = _height + _padding + 2*_outline_size;
        
            var _priority = _width_ext*_texture_page_size + _height_ext;
            ds_priority_add(_priority_queue, _i, _priority);
            show_debug_message("Scribble: Queuing \"" + _character + "\" (" + string(_i) + ") for packing (size=" + string(_width_ext) + "x" + string(_height_ext) + ", weight=" + string(_priority) + ")");
        }
    }
    
    ++_i;
}



show_debug_message("Scribble: " + string(ds_priority_size(_priority_queue)) + " glyphs to pack");

var _index       = ds_priority_delete_max(_priority_queue);
var _glyph_array = _src_glyphs_array[_index];
var _character   = _glyph_array[SCRIBBLE_GLYPH.CHARACTER];
var _width       = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
var _height      = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
var _width_ext   = _width  + _padding + 2*_outline_size;
var _height_ext  = _height + _padding + 2*_outline_size;

show_debug_message("Scribble: Packing \"" + _character + "\" (" + string(_index) + "), size=" + string(_width_ext) + "," + string(_height_ext));

var _l = _padding;
var _t = _padding;
var _r = _l + _width_ext  - 1;
var _b = _t + _height_ext - 1;

var _surface_glyphs = [[_l, _t, _r, _b, _index, _character]];
show_debug_message("Scribble:    " + string(_l) + "," + string(_t) + " -> " + string(_r) + "," + string(_b));

var _added_count = 1;
while(!ds_priority_empty(_priority_queue))
{
    var _index       = ds_priority_delete_max(_priority_queue);
    var _glyph_array = _src_glyphs_array[_index];
    var _character   = _glyph_array[SCRIBBLE_GLYPH.CHARACTER];
    var _width       = _glyph_array[SCRIBBLE_GLYPH.WIDTH    ];
    var _height      = _glyph_array[SCRIBBLE_GLYPH.HEIGHT   ];
    var _width_ext   = _width  + _padding + 2*_outline_size;
    var _height_ext  = _height + _padding + 2*_outline_size;
    
    show_debug_message("Scribble: Packing \"" + _character + "\" (" + string(_index) + "), size=" + string(_width_ext) + "," + string(_height_ext));
    
    var _found = false;
    
    //Scan to the right of each glyph to try to find a free spot
    if (!_found)
    {
        for( var _j = 0; _j < _added_count; _j++ )
        {
            var _target_array = _surface_glyphs[_j];
            var _l = _target_array[2] + 1;
            var _t = _target_array[1];
            var _r = _l + _width_ext  - 1;
            var _b = _t + _height_ext - 1;
        
            if ((_r < _texture_page_size) && (_b < _texture_page_size))
            {
                _found = true;
                //show_debug_message("Scribble:    Trying to the right of \"" + string(_target_array[5]) + "\"");
                
                for( var _k = 0; _k < _added_count; _k++ )
                {
                    var _check_array = _surface_glyphs[_k];
                    var _check_l = _check_array[0];
                    var _check_t = _check_array[1];
                    var _check_r = _check_array[2];
                    var _check_b = _check_array[3];
                    
                    if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                    {
                        _found = false;
                        break;
                    }
                }
                
                if (_found) break;
            }
        }
    }
        
    //If we've not found a free space yet, try scanning underneath each font texture
    if (!_found)
    {
        for( var _j = 0; _j < _added_count; _j++ )
        {
            var _target_array = _surface_glyphs[_j];
            var _l = _target_array[0];
            var _t = _target_array[3] + 1;
            var _r = _l + _width_ext  - 1;
            var _b = _t + _height_ext - 1;
            
            if ((_r < _texture_page_size) && (_b < _texture_page_size))
            {
                _found = true;
                //show_debug_message("Scribble:    Trying beneath \"" + string(_target_array[5]) + "\"");
                
                for(var _k = 0; _k < _added_count; _k++)
                {
                    var _check_array = _surface_glyphs[_k];
                    var _check_l = _check_array[0];
                    var _check_t = _check_array[1];
                    var _check_r = _check_array[2];
                    var _check_b = _check_array[3];
                    
                    if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                    {
                        _found = false;
                        break;
                    }
                }
                
                if (_found) break;
            }
        }
    }
        
    if (_found)
    {
        _surface_glyphs[@ _added_count] = [_l, _t, _r, _b, _index, _character];
        show_debug_message("Scribble:    " + string(_l) + "," + string(_t) + " -> " + string(_r) + "," + string(_b));
        ++_added_count;
    }
    else
    {
        break;
    }
}

if (_found)
{
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, global.__scribble_passthrough_vertex_format);
    
    var _i = 0;
    repeat(array_length_1d(_surface_glyphs))
    {
        var _glyph_position = _surface_glyphs[_i];
        var _index = _glyph_position[4];
        var _glyph_array = _src_glyphs_array[_index];
        
        var _l  = _glyph_position[0] + _outline_size;
        var _t  = _glyph_position[1] + _outline_size;
        var _r  = _l + _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
        var _b  = _t + _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
        var _u0 = _glyph_array[SCRIBBLE_GLYPH.U0];
        var _v0 = _glyph_array[SCRIBBLE_GLYPH.V0];
        var _u1 = _glyph_array[SCRIBBLE_GLYPH.U1];
        var _v1 = _glyph_array[SCRIBBLE_GLYPH.V1];
        
        vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        ++_i;
    }
    
    vertex_end(_vbuff);
    
    var _surface_0 = surface_create(_texture_page_size, _texture_page_size);
    var _surface_1 = surface_create(_texture_page_size, _texture_page_size);
    
    surface_set_target(_surface_0);
    draw_clear_alpha(c_black, 0.0);
    vertex_submit(_vbuff, pr_trianglelist, _src_array[__SCRIBBLE_FONT.TEXTURE]);
    vertex_delete_buffer(_vbuff);
    surface_reset_target();
    
    
    surface_set_target(_surface_1);
    draw_clear_alpha(c_black, 0.0);
    
    gpu_set_fog(true, _outline_color, 0, 0);
    var _y = -_outline_size;
    repeat(2*_outline_size + 1)
    {
        var _x = -_outline_size;
        repeat(2*_outline_size + 1)
        {
            if ((_x != 0) || (_y != 0))
            {
                draw_surface_ext(_surface_0, _x, _y, 1, 1, 0, c_black, 1.0);
            }
            
            ++_x;
        }
        ++_y;
    }
    gpu_set_fog(false, _outline_color, 0, 0);
    
    draw_surface_ext(_surface_0, 0, 0, 1, 1, 0, c_white, 1.0);
    surface_reset_target();
    
    surface_free(_surface_0);
    var _sprite = sprite_create_from_surface(_surface_1, 0, 0, _texture_page_size, _texture_page_size, false, false, 0, 0);
    surface_free(_surface_1);
    
    sprite_save(_sprite, 0, "outline.png");
}
else
{
    show_error("Scribble:\nNo space left on " + string(_texture_page_size) + "x" + string(_texture_page_size) + " texture page\nPlease increase the size of the texture page\n ", false);
}



ds_priority_destroy(_priority_queue);