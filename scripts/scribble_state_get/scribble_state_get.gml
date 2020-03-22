/// Returns an array of data that reflects the current draw state of Scribble.
/// This can be used to debug code, or used in combination with scribble_state_set() to create template draw states.

var _array = array_create(SCRIBBLE_STATE.__SIZE);
_array[@ SCRIBBLE_STATE.XSCALE         ] = scribble_state_xscale;
_array[@ SCRIBBLE_STATE.YSCALE         ] = scribble_state_yscale;
_array[@ SCRIBBLE_STATE.ANGLE          ] = scribble_state_angle;
_array[@ SCRIBBLE_STATE.COLOR          ] = scribble_state_color;
_array[@ SCRIBBLE_STATE.ALPHA          ] = scribble_state_alpha;
_array[@ SCRIBBLE_STATE.LINE_MIN_HEIGHT] = scribble_state_line_min_height;
_array[@ SCRIBBLE_STATE.MAX_WIDTH      ] = scribble_state_max_width;
_array[@ SCRIBBLE_STATE.MAX_HEIGHT     ] = scribble_state_max_height;
_array[@ SCRIBBLE_STATE.CHARACTER_WRAP ] = scribble_state_character_wrap;
_array[@ SCRIBBLE_STATE.HALIGN         ] = scribble_state_box_halign;
_array[@ SCRIBBLE_STATE.VALIGN         ] = scribble_state_box_valign;
_array[@ SCRIBBLE_STATE.ANIMATION_ARRAY] = global.__scribble_shader_property_value_array;
return _array;