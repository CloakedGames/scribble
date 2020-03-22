/// Resets Scribble's draw state to use pass-through values, inheriting defaults set in __scribble_config().

global.__scribble_state_xscale          = SCRIBBLE_DEFAULT_XSCALE;
global.__scribble_state_yscale          = SCRIBBLE_DEFAULT_YSCALE;
global.__scribble_state_angle           = SCRIBBLE_DEFAULT_ANGLE;
global.__scribble_state_color           = SCRIBBLE_DEFAULT_BLEND_COLOR;
global.__scribble_state_alpha           = SCRIBBLE_DEFAULT_BLEND_ALPHA;
global.__scribble_state_line_min_height = SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT;
global.__scribble_state_max_width       = SCRIBBLE_DEFAULT_MAX_WIDTH;
global.__scribble_state_max_height      = SCRIBBLE_DEFAULT_MAX_HEIGHT;
global.__scribble_state_character_wrap  = false;
global.__scribble_state_box_halign      = SCRIBBLE_DEFAULT_BOX_HALIGN;
global.__scribble_state_box_valign      = SCRIBBLE_DEFAULT_BOX_VALIGN;
array_copy(global.__scribble_state_anim_array, 0, global.__scribble_default_anim_array, 0, SCRIBBLE_MAX_DATA_FIELDS);