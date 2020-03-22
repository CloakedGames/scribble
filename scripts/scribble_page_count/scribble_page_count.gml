/// @param string(orElement)

var _scribble_array = argument0;

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
        _scribble_array = scribble_cache(_string);
    }
}

return _scribble_array[__SCRIBBLE.PAGES];