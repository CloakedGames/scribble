/// Draws text using Scribble's formatting.
/// 
/// 
/// Returns: A Scribble text element (which is really a complex array)
/// @param x              The x position in the room to draw at.
/// @param y              The y position in the room to draw at.
/// @param content        The text to be drawn. See below for formatting help.
///                       Alternatively, you can pass a text element into this argument from a previous call to scribble_draw() e.g. for pre-caching.
/// @param [occuranceID]
/// 
/// 
/// Formatting commands:
/// []                                  Reset formatting to defaults
/// [/page]                             Page break
/// [<name of color>]                   Set color
/// [#<hex code>]                       Set color via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)
/// [/color] [/c]                       Reset color to the default
/// [<name of font>] [/font] [/f]       Set font / Reset font
/// [<name of sprite>]                  Insert an animated sprite starting on image 0 and animating using SCRIBBLE_DEFAULT_SPRITE_SPEED
/// [<name of sprite>,<image>]          Insert a static sprite using the specified image index
/// [<name of sprite>,<image>,<speed>]  Insert animated sprite using the specified image index and animation speed
/// [fa_left]                           Align horizontally to the left. This will insert a line break if used in the middle of a line of text
/// [fa_right]                          Align horizontally to the right. This will insert a line break if used in the middle of a line of text
/// [fa_center] [fa_centre]             Align centrally. This will insert a line break if used in the middle of a line of text
/// [scale,<factor>] [/scale] [/s]      Scale text / Reset scale to x1
/// [slant] [/slant]                    Set/unset italic emulation
/// [<event name>,<arg0>,<arg1>...]     Execute a script bound to an event name,previously defined using scribble_add_event(), with the specified arguments
/// [<effect name>] [/<effect name>]    Set/unset an effect
/// 
/// Scribble has the following formatting effects by default:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colors
/// [wobble]  [/wobble]                 Set/unset text to wobble by rotating back and forth
/// [pulse]   [/pulse]                  Set/unset text to shrink and grow rhythmically

var _draw_x      = argument[0];
var _draw_y      = argument[1];
var _draw_string = argument[2];
var _occurance   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_OCCURANCE_ID;



if (!is_array(_draw_string))
{
    var _scribble_array = scribble_cache(_draw_string);
}
else
{
    var _scribble_array = _draw_string;
    
    if ((array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
     || (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
    {
        show_error("Scribble:\nArray passed to scribble_draw() is not a valid Scribble text element.\n ", false);
        return undefined;
    }
    else if (_scribble_array[__SCRIBBLE.FREED])
    {
        //This text element has had its memory freed already, ignore it
        return undefined;
    }
}



var _occurance_array = scribble_occurance(_scribble_array, _occurance);
var _element_pages_array = _scribble_array[__SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];

//Handle the animation timer
var _increment_timers = ((current_time - _occurance_array[__SCRIBBLE_OCCURANCE.LAST_DRAW_TIME]) > __SCRIBBLE_EXPECTED_FRAME_TIME);
var _animation_time   = _occurance_array[__SCRIBBLE_OCCURANCE.ANIMATION_TIME];
_occurance_array[@ __SCRIBBLE_OCCURANCE.LAST_DRAW_TIME] = current_time;

if (_increment_timers)
{
    _animation_time += SCRIBBLE_STEP_SIZE;
    _occurance_array[@ __SCRIBBLE_OCCURANCE.ANIMATION_TIME] = _animation_time;
}

//Figure out the left/top offset
switch(scribble_state_box_halign)
{
    case fa_center: var _left = -_scribble_array[__SCRIBBLE.WIDTH] div 2; break;
    case fa_right:  var _left = -_scribble_array[__SCRIBBLE.WIDTH];       break;
    default:        var _left = 0;                                        break;
}

switch(scribble_state_box_valign)
{
    case fa_middle: var _top = -_scribble_array[__SCRIBBLE.HEIGHT] div 2; break;
    case fa_bottom: var _top = -_scribble_array[__SCRIBBLE.HEIGHT];       break;
    default:        var _top = 0;                                         break;
}

//Build a matrix to transform the text...
if ((scribble_state_xscale == 1.0)
&&  (scribble_state_yscale == 1.0)
&&  (scribble_state_angle  == 0.0))
{
    var _matrix = matrix_build(_left + _draw_x, _top + _draw_y, 0,   0,0,0,   1,1,1);
}
else
{
    var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
        _matrix = matrix_multiply(_matrix, matrix_build(_draw_x, _draw_y, 0,
                                                        0, 0, scribble_state_angle,
                                                        scribble_state_xscale, scribble_state_yscale, 1));
}

//...aaaand set the matrix
var _old_matrix = matrix_get(matrix_world);
_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

var _page_vbuffs_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
var _count = array_length_1d(_page_vbuffs_array);
if (_count > 0)
{
    var _typewriter_method = _occurance_array[__SCRIBBLE_OCCURANCE.TW_METHOD];
    if (_typewriter_method == SCRIBBLE_TW_NONE)
    {
        //If the text element's internal typewriter method hasn't been set then show all the text
            _typewriter_method     = SCRIBBLE_TW_NONE;
        var _typewriter_smoothness = 0.0;
        var _typewriter_position   = 1.0;
        var _typewriter_fade_in    = true;
        var _typewriter_speed      = 0;
    }
    else
    {
        var _typewriter_smoothness = _occurance_array[__SCRIBBLE_OCCURANCE.TW_SMOOTHNESS];
        var _typewriter_position   = _occurance_array[__SCRIBBLE_OCCURANCE.TW_POSITION  ];
        var _typewriter_fade_in    = _occurance_array[__SCRIBBLE_OCCURANCE.TW_FADE_IN   ];
        var _typewriter_speed      = _occurance_array[__SCRIBBLE_OCCURANCE.TW_SPEED     ]*SCRIBBLE_STEP_SIZE;
        
        #region Scan for typewriter events
        
        if ((_typewriter_fade_in >= 0) && (_typewriter_speed > 0))
        {
            //Find the last character we need to scan
            switch(_typewriter_method)
            {
                case SCRIBBLE_TW_PER_CHARACTER:
                    var _scan_b = ceil(_typewriter_position + _typewriter_speed);
                break;
                
                case SCRIBBLE_TW_PER_LINE:
                    var _page_lines_array = _page_array[__SCRIBBLE_PAGE.LINES_ARRAY];
                    var _line   = _page_lines_array[min(ceil(_typewriter_position + _typewriter_speed), _page_array[__SCRIBBLE_PAGE.LINES]-1)];
                    var _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
                break;
            }
            
            var _scan_a = _occurance_array[__SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS];
            if (_scan_b > _scan_a)
            {
                //Play a sound effect as the text is revealed
                var _sound_array = _occurance_array[__SCRIBBLE_OCCURANCE.TW_SOUND_ARRAY];
                if (is_array(_sound_array) && (array_length_1d(_sound_array) > 0))
                {
                    if (current_time >= _occurance_array[__SCRIBBLE_OCCURANCE.TW_SOUND_FINISH_TIME]) 
                    {
                        global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
                        var _sound = _sound_array[floor(array_length_1d(_sound_array) * global.__scribble_lcg / 2147483648)];
                        
                        var _inst = audio_play_sound(_sound, 0, false);
                        audio_sound_pitch(_inst, random_range(_occurance_array[__SCRIBBLE_OCCURANCE.TW_SOUND_MIN_PITCH], _occurance_array[__SCRIBBLE_OCCURANCE.TW_SOUND_MAX_PITCH]));
                        
                        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_FINISH_TIME] = current_time + 1000*audio_sound_length(_sound) - _occurance_array[__SCRIBBLE_OCCURANCE.TW_SOUND_OVERLAP];
                    }
                }
                    
                var _events_char_array = _page_array[__SCRIBBLE_PAGE.EVENT_CHAR_ARRAY];
                var _events_name_array = _page_array[__SCRIBBLE_PAGE.EVENT_NAME_ARRAY];
                var _events_data_array = _page_array[__SCRIBBLE_PAGE.EVENT_DATA_ARRAY];
                var _event_count       = array_length_1d(_events_char_array);
                var _event             = _occurance_array[__SCRIBBLE_OCCURANCE.EVENT_PREVIOUS];
                
                //Always start scanning at the next event
                ++_event;
                if (_event < _event_count)
                {
                    var _event_char = _events_char_array[_event];
                        
                    //Now iterate from our current character position to the next character position
                    var _break = false;
                    var _scan = _scan_a;
                    repeat(_scan_b - _scan_a)
                    {
                        while ((_event < _event_count) && (_event_char == _scan))
                        {
                            var _script = global.__scribble_typewriter_events[? _events_name_array[_event]];
                            if (_script != undefined)
                            {
                                _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_PREVIOUS] = _event;
                                script_execute(_script, _scribble_array, _occurance, _events_data_array[_event], _scan);
                            }
                                
                            if (_occurance_array[__SCRIBBLE_OCCURANCE.TW_SPEED] <= 0.0)
                            {
                                _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SPEED] = 0;
                                _typewriter_speed = 0;
                                _break = true;
                                break;
                            }
                                
                            ++_event;
                            if (_event < _event_count) _event_char = _events_char_array[_event];
                        }
                            
                        if (_break) break;
                        ++_scan;
                    }
                        
                    if (_break && (_typewriter_method == SCRIBBLE_TW_PER_CHARACTER)) _typewriter_position = _scan;
                    
                    _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS] = _scan;
                }
                else
                {
                    _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS] = _scan_b;
                }
            }
        }
            
        #endregion
    }
    
    //Figure out the limit and smoothness values
    if (_typewriter_method == SCRIBBLE_TW_NONE)
    {
        var _typewriter_smoothness = 0;
        var _typewriter_t          = 1;
    }
    else
    {
        switch(_typewriter_method)
        {
            case SCRIBBLE_TW_PER_CHARACTER: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
            case SCRIBBLE_TW_PER_LINE:      var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
        }
        
        var _typewriter_t = clamp(_typewriter_position, 0, _typewriter_count + _typewriter_smoothness);
        _typewriter_t *= 1 + _typewriter_smoothness/_typewriter_count; //Correct for smoothness
        
        //If it's been around-about a frame since we called this scripts...
        if (_increment_timers)
        {
            //...then advance the typewriter position
            _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_POSITION] = clamp(_typewriter_position + _typewriter_speed, 0, _typewriter_count);
        }
    }
    
    //Use a negative typewriter method to communicate a fade-out state to the shader
    //It's a bit hacky but it reduces the uniform count for the shader
    if (!_typewriter_fade_in) _typewriter_method = -_typewriter_method;
    
    //Set the shader and its uniforms
    shader_set(shd_scribble);
    shader_set_uniform_f(global.__scribble_uniform_time         , _animation_time);
    shader_set_uniform_f(global.__scribble_uniform_z            , SCRIBBLE_Z);
    
    shader_set_uniform_f(global.__scribble_uniform_tw_method    , _typewriter_method);
    shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _typewriter_smoothness);
    shader_set_uniform_f(global.__scribble_uniform_tw_t         , _typewriter_t);
    
    shader_set_uniform_f(global.__scribble_uniform_color_blend  , color_get_red(  scribble_state_color)/255,
                                                                  color_get_green(scribble_state_color)/255,
                                                                  color_get_blue( scribble_state_color)/255,
                                                                  scribble_state_alpha);
    
    shader_set_uniform_f_array(global.__scribble_uniform_properties, global.__scribble_shader_property_value_array);
    
    //Now iterate over the text element's vertex buffers and submit them
    var _i = 0;
    repeat(_count)
    {
        var _vbuff_data = _page_vbuffs_array[_i];
        shader_set_uniform_f(global.__scribble_uniform_texel, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH], _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT]);
        vertex_submit(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
        ++_i;
    }
    
    shader_reset();
}

//Make sure we reset the world matrix
matrix_set(matrix_world, _old_matrix);



//Update when this text element was last drawn
_scribble_array[@ __SCRIBBLE.LAST_DRAW_TIME] = current_time;
    


#region Check to see if we need to free some memory from the global cache list

if (SCRIBBLE_CACHE_TIMEOUT > 0)
{
    var _size = ds_list_size(global.__scribble_global_cache_list);
    if (_size > 0)
    {
        //Scan through the cache to see if any text elements have elapsed
        global.__scribble_cache_test_index = (global.__scribble_cache_test_index + 1) mod _size;
        var _cache_string = global.__scribble_global_cache_list[| global.__scribble_cache_test_index];
        var _cache_array = global.__scribble_global_cache_map[? _cache_string];
        
        if (!is_array(_cache_array)
        || (array_length_1d(_cache_array) != __SCRIBBLE.__SIZE)
        || (_cache_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
        || _cache_array[__SCRIBBLE.FREED])
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: \"" + _cache_string + "\" exists in cache but doesn't exist elsewhere");
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
        else if (_cache_array[__SCRIBBLE.LAST_DRAW_TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _cache_string + "\" from cache");
            
            var _element_pages_array = _cache_array[__SCRIBBLE.PAGES_ARRAY];
            var _p = 0;
            repeat(array_length_1d(_element_pages_array))
            {
                var _page_array = _element_pages_array[_p];
                var _vertex_buffers_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
                var _v = 0;
                repeat(array_length_1d(_vertex_buffers_array))
                {
                    var _vbuff_data = _vertex_buffers_array[_v];
                    var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
                    vertex_delete_buffer(_vbuff);
                    ++_v;
                }
                ++_p;
            }
            
            ds_map_destroy(_scribble_array[@ __SCRIBBLE.OCCURANCE_MAP]);
            _cache_array[@ __SCRIBBLE.FREED] = true;
            
            //Remove reference from cache
            ds_map_delete(global.__scribble_global_cache_map, _cache_string);
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
    }
}

#endregion



return _scribble_array;