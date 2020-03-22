scribble_state_box_halign = fa_center;
scribble_state_box_valign = fa_middle;

scribble_draw(x, y, element);

var _bbox = scribble_get_bbox(element,   x, y,   5, 5,   5, 5);
draw_rectangle(_bbox[SCRIBBLE_BBOX.L], _bbox[SCRIBBLE_BBOX.T],
               _bbox[SCRIBBLE_BBOX.R], _bbox[SCRIBBLE_BBOX.B], true);

scribble_state_reset();