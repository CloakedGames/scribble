/// @param [name]

var _name = (argument_count > 0)? argument[0] : undefined;

var _array = array_create(__SCRIBBLE_READER.__SIZE);
_array[@ __SCRIBBLE_READER.NAME             ] = _name;
_array[@ __SCRIBBLE_READER.PAGE             ] =  0;
_array[@ __SCRIBBLE_READER.FADE_IN          ] = -1;
_array[@ __SCRIBBLE_READER.SPEED            ] =  0;
_array[@ __SCRIBBLE_READER.POSITION         ] =  0;
_array[@ __SCRIBBLE_READER.METHOD           ] = SCRIBBLE_TW_NONE;
_array[@ __SCRIBBLE_READER.SMOOTHNESS       ] =  0;
_array[@ __SCRIBBLE_READER.SOUND_ARRAY      ] = -1;
_array[@ __SCRIBBLE_READER.SOUND_OVERLAP    ] =  0;
_array[@ __SCRIBBLE_READER.SOUND_MIN_PITCH  ] =  1.0;
_array[@ __SCRIBBLE_READER.SOUND_MAX_PITCH  ] =  1.0;
_array[@ __SCRIBBLE_READER.SOUND_FINISH_TIME] = current_time;

if (_name == undefined)
{
    _name = irandom(99999);
    global.__scribble_reader_map[? _name] = _array;
}

return _array;