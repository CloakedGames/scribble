/// Scribble's macros, used to customise and control behaviour throughout the library.



#macro SCRIBBLE_HASH_NEWLINE        true   //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour
#macro SCRIBBLE_COLORIZE_SPRITES    true   //Whether to apply the text color to non-animated sprites (animated sprites are always blended white)
#macro SCRIBBLE_VERBOSE             false  //Enables verbose console output to aid with debugging
#macro SCRIBBLE_ADD_SPRITE_ORIGINS  false  //Whether to use sprite origins. Setting this to <false> will vertically centre sprites on the line of text



//Starting format
#macro SCRIBBLE_DEFAULT_TEXT_COLOR    c_white  //The default (vertex) color of text
#macro SCRIBBLE_DEFAULT_HALIGN        fa_left
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED  0.1      //The default animation speed for sprites inserted into text



#region Advanced stuff

#macro SCRIBBLE_STEP_SIZE             (delta_time/game_get_speed(gamespeed_microseconds)) //The animation step size. The default command here uses delta_time ensures that animations are smooth at all framerates
#macro SCRIBBLE_SLANT_AMOUNT          0.24  //The x-axis displacement when using the [slant] tag
#macro SCRIBBLE_Z                     0     //The z-value for vertexes

#macro SCRIBBLE_DEFAULT_CACHE_GROUP   "__default__" //The name of the default cache group. Real value and strings accepted
#macro SCRIBBLE_DEFAULT_OCCURANCE_ID  "__default__"
#macro SCRIBBLE_CACHE_TIMEOUT         15000 //How long to wait (in milliseconds) before the cache automatically destroys a text element. Set to 0 (or less) to turn off automatic de-caching (you'll need to manually call scribble_flush() instead)

#macro SCRIBBLE_COMMAND_TAG_OPEN      ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE     ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only

//Normally, Scribble will try to sequentially store glyph data in an array for fast lookup.
//However, some font definitons may have disjointed character indexes (e.g. Chinese). Scribble will detect these fonts and use a ds_map instead for glyph data lookup
#macro SCRIBBLE_SEQUENTIAL_GLYPH_TRY        true
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE  300  //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES  0.50 //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map

//These constants must match the corresponding values in shader shd_scribble
#macro SCRIBBLE_SHADER_MAX_EFFECTS        6  //The maximum number of unique effects. Effects are set as booleans, and are sent into shd_scribble as a bitpacked number
#macro SCRIBBLE_SHADER_MAX_PROPERTIES    11  //The maximum number of shader properties
#macro SCRIBBLE_MAX_LINES              1000  //Maximum number of lines in a textbox

#endregion



#macro SCRIBBLE_WARNING_AUTOSCAN_YY_NOT_FOUND  true