/// @param stateArray   The array of data that will be copied into Scribble's internal draw state.
/// 
/// 
/// Updates Scribble's current draw state from an array. Any value that is <undefined> will use the default value instead.
/// This can be used in combination with scribble_state_get() to create template draw states.

scribble_state_xscale          = argument0[SCRIBBLE_STATE.XSCALE         ];
scribble_state_yscale          = argument0[SCRIBBLE_STATE.YSCALE         ];
scribble_state_angle           = argument0[SCRIBBLE_STATE.ANGLE          ];
scribble_state_color           = argument0[SCRIBBLE_STATE.COLOR          ];
scribble_state_alpha           = argument0[SCRIBBLE_STATE.ALPHA          ];
scribble_state_line_min_height = argument0[SCRIBBLE_STATE.LINE_MIN_HEIGHT];
scribble_state_max_width       = argument0[SCRIBBLE_STATE.MAX_WIDTH      ];
scribble_state_max_height      = argument0[SCRIBBLE_STATE.MAX_HEIGHT     ];
scribble_state_character_wrap  = argument0[SCRIBBLE_STATE.CHARACTER_WRAP ];
scribble_state_box_halign      = argument0[SCRIBBLE_STATE.HALIGN         ];
scribble_state_box_valign      = argument0[SCRIBBLE_STATE.VALIGN         ];

global.__scribble_shader_property_value_array = argument0[SCRIBBLE_STATE.ANIMATION_ARRAY];