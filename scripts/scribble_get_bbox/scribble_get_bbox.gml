/// Gets the position of each corner of the textbox for a text element.
/// 
/// 
/// Returns: an 8-element array containing the positions of each corner of the text element's box (use the SCRIBBLE_BBOX enum to get each coordinate pair).
/// @param string(orElement)   The text to get the bounding box for. Alternatively, you can pass a text element into this argument from a previous call to scribble_draw().
/// @param x                   The x position in the room to draw at. Defaults to 0
/// @param y                   The y position in the room to draw at. Defaults to 0
/// @param [leftMargin]        The additional space to add to the left-hand side of the box. Positive values create more space. Defaults to 0
/// @param [topMargin]         The additional space to add to the top of the box. Positive values create more space. Defaults to 0
/// @param [rightMargin]       The additional space to add to the right-hand side of the box. Positive values create more space. Defaults to 0
/// @param [bottomMargin]      The additional space to add to the bottom of the box. Positive values create more space. Defaults to 0
/// 
/// All optional arguments accept <undefined> to indicate that the default value should be used.

enum SCRIBBLE_BBOX
{
    L, T, R, B,
    X0, Y0, //Top left corner
    X1, Y1, //Top right corner
    X2, Y2, //Bottom left corner
    X3, Y3, //Bottom right corner
    __SIZE
}

var _scribble_array = argument[0];
var _x              = argument[1];
var _y              = argument[2];
var _margin_l       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _margin_t       = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _margin_r       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _margin_b       = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;

if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
|| _scribble_array[__SCRIBBLE.FREED])
{
    var _string = string(_scribble_array);
    
    //Check the cache
    var _cache_string = _string + ":" + string(scribble_state_line_min_height) + ":" + string(scribble_state_max_width) + ":" + string(scribble_state_max_height);
    if (ds_map_exists(global.__scribble_global_cache_map, _cache_string))
    {
        var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
    }
    else
    {
        scribble_cache(_string);
    }
}

switch(scribble_state_box_halign)
{
    case fa_left:
        var _box_l = 0;
        var _box_r = _scribble_array[__SCRIBBLE.WIDTH];
    break;
    
    case fa_center:
        var _box_l = -_scribble_array[__SCRIBBLE.WIDTH] div 2;
        var _box_r = -_box_l;
    break;
    
    case fa_right:
        var _box_l = -_scribble_array[__SCRIBBLE.WIDTH];
        var _box_r = 0;
    break;
}

switch(scribble_state_box_valign)
{
    case fa_top:
        var _box_t = 0;
        var _box_b = _scribble_array[__SCRIBBLE.HEIGHT];
    break;
    
    case fa_middle:
        var _box_t = -_scribble_array[__SCRIBBLE.HEIGHT] div 2;
        var _box_b = -_box_t;
    break;
    
    case fa_bottom:
        var _box_t = -_scribble_array[__SCRIBBLE.HEIGHT];
        var _box_b = 0;
    break;
}

if ((scribble_state_xscale == 1)
&&  (scribble_state_yscale == 1)
&&  (scribble_state_angle  == 0))
{
    //Avoid using matrices if we can
    var _l = _x + _box_l - _margin_l;
    var _t = _y + _box_t - _margin_t;
    var _r = _x + _box_r + _margin_r;
    var _b = _y + _box_b + _margin_b;
    
    return [_l, _t, _r, _b, //AABB
            _l, _t,         //OBB
            _r, _t,
            _l, _b,
            _r, _b];
}

var _matrix = matrix_build(_x, _y, 0, 
    	                    0, 0, scribble_state_angle,
    	                    scribble_state_xscale, scribble_state_yscale, 1);

var _l = _box_l - _margin_l;
var _t = _box_t - _margin_t;
var _r = _box_r + _margin_r;
var _b = _box_b + _margin_b;

var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); var _x0 = _vertex[0]; var _y0 = _vertex[1];
    _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); var _x1 = _vertex[0]; var _y1 = _vertex[1];
    _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); var _x2 = _vertex[0]; var _y2 = _vertex[1];
    _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); var _x3 = _vertex[0]; var _y3 = _vertex[1];

return [min(_x0, _x1, _x2, _x3), //AABB
        min(_y0, _y1, _y2, _y3),
        max(_x0, _x1, _x2, _x3),
        max(_y0, _y1, _y2, _y3),
        _x0, _y0,                //OBB
        _x1, _y1,
        _x2, _y2,
        _x3, _y3];