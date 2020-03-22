if (keyboard_check_pressed(vk_anykey))
{
    var _state = scribble_tw_get(element);
    if (_state == 1)
    {
        scribble_tw_fade_out(element, SCRIBBLE_TW_PER_CHARACTER, 0.5, 0);
    }
    else if (_state == 2) 
    {
        scribble_tw_fade_in(element, SCRIBBLE_TW_PER_CHARACTER, 0.5, 0);
    }
}