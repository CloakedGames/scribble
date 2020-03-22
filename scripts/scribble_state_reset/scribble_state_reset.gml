/// Resets Scribble's draw state to use pass-through values, inheriting defaults set in __scribble_config().

scribble_state_xscale          = 1.0;
scribble_state_yscale          = 1.0;
scribble_state_angle           = 0.0;
scribble_state_color           = c_white;
scribble_state_alpha           = 1.0;
scribble_state_line_min_height = -1;
scribble_state_max_width       = -1;
scribble_state_max_height      = -1;
scribble_state_character_wrap  = false;
scribble_state_box_halign      = fa_left;
scribble_state_box_valign      = fa_top;

array_copy(global.__scribble_shader_property_value_array, 0, global.__scribble_shader_property_default_array, 0, SCRIBBLE_SHADER_MAX_PROPERTIES);