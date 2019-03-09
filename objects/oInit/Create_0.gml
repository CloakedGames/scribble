//  Scribble (light) v2.5.1
//  2019/03/09
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

//Start up Scribble and load some fonts
scribble_init_start( 2048 ); //Set to the same value as the texture page size for your target platform
scribble_init_add_font( "fTestA" ); //The first font added is the default font
scribble_init_add_font( "fTestB" );
scribble_init_add_spritefont( "sSpriteFont", 3 ); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width
scribble_init_add_font( "fChineseTest" );
scribble_init_end();

//Define a custom colour for use later in our text
scribble_add_custom_colour( "c_test", make_colour_rgb( 100, 150, 200 ) );

//You can define custom events that execute scripts
//Here's a basic example of playing a sound
scribble_add_event( "sound", play_sound_example );

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();