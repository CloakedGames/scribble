/// Returns an array of data that reflects the current draw state of Scribble.
/// This can be used to debug code, or used in combination with scribble_set_state() to create template draw states.

var _array = array_create(SCRIBBLE_STATE.__SIZE);
_array[@ SCRIBBLE_STATE.XSCALE         ] = global.__scribble_state_xscale;
_array[@ SCRIBBLE_STATE.YSCALE         ] = global.__scribble_state_yscale;
_array[@ SCRIBBLE_STATE.ANGLE          ] = global.__scribble_state_angle;
_array[@ SCRIBBLE_STATE.COLOR          ] = global.__scribble_state_color;
_array[@ SCRIBBLE_STATE.ALPHA          ] = global.__scribble_state_alpha;
_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT] = global.__scribble_state_line_min_height;
_array[@ SCRIBBLE_STATE.MAX_WIDTH      ] = global.__scribble_state_max_width;
_array[@ SCRIBBLE_STATE.MAX_HEIGHT     ] = global.__scribble_state_max_height;
_array[@ SCRIBBLE_STATE.CHARACTER_WRAP ] = global.__scribble_state_character_wrap;
_array[@ SCRIBBLE_STATE.HALIGN         ] = global.__scribble_state_box_halign;
_array[@ SCRIBBLE_STATE.VALIGN         ] = global.__scribble_state_box_valign;
_array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = global.__scribble_animation_value_array;
return _array;