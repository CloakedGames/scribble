scribble_draw(text, x, y);
var _box = scribble_get_box(text,   x, y,   0, 0,   0, 0);
draw_rectangle(_box[SCRIBBLE_BOX.X0], _box[SCRIBBLE_BOX.Y0],
               _box[SCRIBBLE_BOX.X3], _box[SCRIBBLE_BOX.Y3], true);

//draw_set_font(spritefont);
//draw_text(10, 10, test_string);
//draw_set_font(-1);
//scribble_draw(test_text, 10, 30);

draw_set_font(font_cutscene);
draw_text(10, 10, "That's right!");
draw_set_font(-1);