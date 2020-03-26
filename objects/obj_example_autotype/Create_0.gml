//Start up Scribble and load fonts automatically from Included Files
scribble_init("fnt_test_0", "Fonts", true);

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_spritefont("spr_sprite_font", _mapstring, 0, 3);

//Add some color definitions that we'll use in the demo string
scribble_init_color("c_coquelicot", $ff3800);
scribble_init_color("c_smaragdine", $50c875);
scribble_init_color("c_xanadu"    , $738678);
scribble_init_color("c_amaranth"  , $e52b50);

scribble_tw_add_event("test event", example_event);



//Define a demo string for use in the Draw event
var _demo_string  = "[rainbow][pulse]abcdef[] ABCDEF[test event]##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][shake][rainbow]!?[]\n";
    _demo_string += "[fa_centre][spr_coin][spr_coin][spr_coin][spr_large_coin][test event]\n";
    _demo_string += "[fa_left][spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1][wobble]DOG[/wobble].";

element = scribble_cache(_demo_string);
scribble_tw_fade_in(element, 0.5, 0, false);
scribble_tw_set_sound(element, [snd_vowel_0, snd_vowel_1, snd_vowel_2, snd_vowel_3, snd_vowel_4], 30, 1.0, 1.1);