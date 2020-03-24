/// @param sourceFontName
/// @param newFontName
/// @param emptyPadding
/// @param leftPad
/// @param topPad
/// @param rightPad
/// @param bottomPad
/// @param texturePageSize

var _source_font_name  = argument0;
var _new_font_name     = argument1;
var _padding           = argument2;
var _l_pad             = argument3;
var _t_pad             = argument4;
var _r_pad             = argument5;
var _b_pad             = argument6;
var _texture_page_size = argument7;

if (_source_font_name == _new_font_name)
{
    show_error("Scribble:\nSource font and new font cannot share the same name\n ", false);
    return undefined;
}



var _h_pad = _padding + _l_pad + _r_pad;
var _v_pad = _padding + _t_pad + _b_pad;



var _src_font_array = global.__scribble_font_data[? _source_font_name];
var _src_glyphs_map = _src_font_array[__SCRIBBLE_FONT.GLYPHS_MAP];
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
    var _src_glyphs_array = _src_font_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
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
            var _width      = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
            var _height     = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
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

ds_priority_destroy(_priority_queue);



if (!_found)
{
    show_error("Scribble:\nNo space left on " + string(_texture_page_size) + "x" + string(_texture_page_size) + " texture page\nPlease increase the size of the texture page\n ", false);
}
else
{
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, global.__scribble_passthrough_vertex_format);
    
    var _i = 0;
    repeat(array_length_1d(_surface_glyphs))
    {
        var _glyph_position = _surface_glyphs[_i];
        var _index = _glyph_position[4];
        var _glyph_array = _src_glyphs_array[_index];
        
        var _l  = _glyph_position[0] + _x_offset;
        var _t  = _glyph_position[1] + _y_offset;
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
    
    
    
    var _texture = _src_font_array[__SCRIBBLE_FONT.TEXTURE];
    var _surface_0 = surface_create(_texture_page_size, _texture_page_size);
    
    surface_set_target(_surface_0);
    draw_clear_alpha(c_white, 0.0);
    gpu_set_blendenable(false);
    vertex_submit(_vbuff, pr_trianglelist, _texture);
    gpu_set_blendenable(true);
    surface_reset_target();
    
    
    vertex_delete_buffer(_vbuff);
    var _surface_1 = surface_create(_texture_page_size, _texture_page_size);
    
    surface_set_target(_surface_1);
    draw_clear_alpha(c_white, 0.0);
    gpu_set_blendenable(false);
    
    if (shader_current() >= 0)
    {
        var _texture = surface_get_texture(_surface_0);
        shader_set_uniform_f(shader_get_uniform(shader_current(), "u_vTexel"), texture_get_texel_width(_texture), texture_get_texel_height(_texture));
    }
    
    draw_surface(0, 0, _surface_0);
    
    gpu_set_blendenable(true);
    surface_reset_target();
    
    surface_free(_surface_0);
    var _sprite = sprite_create_from_surface(_surface_1, 0, 0, _texture_page_size, _texture_page_size, false, false, 0, 0);
    surface_free(_surface_1);
    
    sprite_save(_sprite, 0, "baked.png");
    
    
    
    var _texture = sprite_get_texture(_sprite, 0);
    var _sprite_uvs = sprite_get_uvs(_sprite, 0);
    var _sprite_u0 = _sprite_uvs[0];
    var _sprite_v0 = _sprite_uvs[1];
    var _sprite_u1 = _sprite_uvs[2];
    var _sprite_v1 = _sprite_uvs[3];
    
    var _new_font_array = array_create(__SCRIBBLE_FONT.__SIZE);
    array_copy(_new_font_array, 0, _src_font_array, 0, array_length_1d(_src_font_array));
    _new_font_array[@ __SCRIBBLE_FONT.NAME        ] = _new_font_name;
    _new_font_array[@ __SCRIBBLE_FONT.PATH        ] = undefined;
    _new_font_array[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = undefined;
    _new_font_array[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
    _new_font_array[@ __SCRIBBLE_FONT.TEXTURE     ] = _texture;
    global.__scribble_font_data[? _new_font_name] = _new_font_array;
    
    
    if (_uses_glyph_map)
    {
        var _new_glyph_map = ds_map_create();
        _new_font_array[@ __SCRIBBLE_FONT.GLYPHS_MAP] = _new_glyph_map;
        
        var _array = array_create(SCRIBBLE_GLYPH.__SIZE);
        array_copy(_array, 0, _src_glyphs_map[? 32], 0, SCRIBBLE_GLYPH.__SIZE);
        _new_glyph_map[? 32] = _array;
    }
    else
    {
        var _glyph_min = _new_font_array[__SCRIBBLE_FONT.GLYPH_MIN];
        var _glyph_max = _new_font_array[__SCRIBBLE_FONT.GLYPH_MAX];
        
        var _new_glyph_array = array_create(1 + _glyph_max - _glyph_min, undefined);
        _new_font_array[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = _new_glyph_array;
        
        var _array = array_create(SCRIBBLE_GLYPH.__SIZE);
        array_copy(_array, 0, _src_glyphs_array[32 - _glyph_min], 0, SCRIBBLE_GLYPH.__SIZE);
        _new_glyph_array[@ 32 - _glyph_min] = _array;
    }
    
    var _i = 0;
    repeat(array_length_1d(_surface_glyphs))
    {
        var _glyph_position = _surface_glyphs[_i];
        
        var _index = _glyph_position[4];
        var _src_glyph_array = _src_glyphs_array[_index];
        var _ord = _src_glyph_array[SCRIBBLE_GLYPH.INDEX];
        
        var _l = _glyph_position[0];
        var _t = _glyph_position[1];
        var _r = _l + _src_glyph_array[SCRIBBLE_GLYPH.WIDTH ] + 2*_outline_size;
        var _b = _t + _src_glyph_array[SCRIBBLE_GLYPH.HEIGHT] + 2*_outline_size;
        
        var _u0 = lerp(_sprite_u0, _sprite_u1, _l / _texture_page_size);
        var _v0 = lerp(_sprite_v0, _sprite_v1, _t / _texture_page_size);
        var _u1 = lerp(_sprite_u0, _sprite_u1, _r / _texture_page_size);
        var _v1 = lerp(_sprite_v0, _sprite_v1, _b / _texture_page_size);
        
    	var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
    	_array[@ SCRIBBLE_GLYPH.CHARACTER ] = _src_glyph_array[SCRIBBLE_GLYPH.CHARACTER ];
    	_array[@ SCRIBBLE_GLYPH.INDEX     ] = _ord;
    	_array[@ SCRIBBLE_GLYPH.WIDTH     ] = _src_glyph_array[SCRIBBLE_GLYPH.WIDTH     ] + 2*_outline_size;
    	_array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _src_glyph_array[SCRIBBLE_GLYPH.HEIGHT    ] + 2*_outline_size;
    	_array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _src_glyph_array[SCRIBBLE_GLYPH.X_OFFSET  ] - _x_offset;
    	_array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _src_glyph_array[SCRIBBLE_GLYPH.Y_OFFSET  ] - _y_offset;
    	_array[@ SCRIBBLE_GLYPH.SEPARATION] = _src_glyph_array[SCRIBBLE_GLYPH.SEPARATION] + _outline_size;
    	_array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
    	_array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
    	_array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
    	_array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
        
        if (_uses_glyph_map)
        {
            _new_glyph_map[? _ord] = _array;
        }
        else
        {
    	    _new_glyph_array[@ _ord - _glyph_min] = _array;
        }
        
        ++_i;
    }
}