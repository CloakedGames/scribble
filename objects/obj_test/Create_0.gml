scribble_init("fnt_test_0", "Fonts", true);

//var _fnt_test_3_sprite = sprite_add("Fonts\\fnt_test_3.png", 0, false, false, 0, 0);
//scribble_font_add("fnt_test_3", "fnt_test_3.yy", sprite_get_texture(_fnt_test_3_sprite, 0));

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_spritefont("spr_sprite_font", _mapstring, 0, 11);

scribble_font_bake_outline("spr_sprite_font", "fnt_outline", 1, 4, c_red, false);

scribble_init_color("c_coquelicot", $ff3800);
scribble_init_color("c_smaragdine", $50c875);
scribble_init_color("c_xanadu"    , $738678);
scribble_init_color("c_amaranth"  , $e52b50);

scribble_tw_add_event("pause", example_pause);

scribble_set_glyph_property("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

//Native GM defintions
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
test_string = "The Quick Brown Fox Jumps Over The Lazy Dog!";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 0);

//demo_string  = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
//demo_string += "[rainbow][pulse]TEST[] [slant]AaBbCcDdEeFf[/slant]##";
//demo_string += "a b c d e f g h i j k l m n o p q r s t u v w x y z\n\n";
//demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][][shake][rainbow]!?[]\n";
//demo_string += "[spr_coin][spr_coin,1,0.1][spr_coin,2,0.1][spr_large_coin,3,0.1]    \n";
//demo_string += "[spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
//demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] [/shake]THE LAZY [fnt_test_1][wobble]DOG[/wobble].";
//demo_string += "##[fnt_test_2][c_black]TESTING";

demo_string = "[fnt_outline]Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet...\", comes from a line in section 1.10.32.";

//Now parse the string to make some Scribble data
scribble_state_max_width  = 450;
scribble_state_max_height = 100;

//We're using a cache group called "example cache group" to indicate we want to manage this memory ourselves
element = scribble_cache(demo_string, "example cache group", true);
scribble_page_set(element, 0);
scribble_tw_fade_in(element, 1, 10, false);

//Don't forget to reset the state otherwise all subsequent Scribble text elements will inherit these settings
scribble_state_reset();