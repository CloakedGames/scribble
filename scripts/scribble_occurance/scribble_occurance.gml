/// @param element
/// @param occuranceID
/// @param [allowNew]

var _element   = argument[0];
var _occurance = argument[1];
var _allow_new = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : true;

if (_occurance == SCRIBBLE_DEFAULT_OCCURANCE_ID)
{
    return _element[__SCRIBBLE.OCCURANCE_DEFAULT];
}

var _occurance_map = _element[__SCRIBBLE.OCCURANCE_MAP];
var _occurance_array = _occurance_map[? _occurance];
if (_occurance_array == undefined)
{
    if (_allow_new)
    {
        if (SCRIBBLE_VERBOSE)
        {
            show_debug_message("Scribble: Occurance ID \"" + string(_occurance) + "\" created for text element \"" + string_replace_all(string(_element[__SCRIBBLE.STRING]), "\n", "\\n") + "\"");
        }
        
        _occurance_array = array_create(__SCRIBBLE_OCCURANCE.__SIZE);
        
        _occurance_array[@ __SCRIBBLE_OCCURANCE.ANIMATION_TIME      ] = 0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.LAST_DRAW_TIME      ] = current_time;
        
        _occurance_array[@ __SCRIBBLE_OCCURANCE.PAGE                ] =  0;
        
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_FADE_IN          ] = -1;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SPEED            ] =  0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_POSITION         ] =  0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_METHOD           ] = SCRIBBLE_TW_NONE;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SMOOTHNESS       ] =  0;
        
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_ARRAY      ] = -1;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_OVERLAP    ] =  0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_MIN_PITCH  ] =  1.0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_MAX_PITCH  ] =  1.0;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.TW_SOUND_FINISH_TIME] = current_time;
        
        _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_PREVIOUS      ] = -1;
        _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS ] = -1;
        
        _occurance_map[? _occurance] = _occurance_array;
    }
    else
    {
        show_error("Scribble:\nOccurance ID \"" + string(_occurance) + "\" not found for text element \"" + string(_element[__SCRIBBLE.STRING]) + "\"\n ", false);
    }
}

return _occurance_array;