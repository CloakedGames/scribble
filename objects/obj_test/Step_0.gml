if (keyboard_check_pressed(vk_space))
{
    if (scribble_tw_get(element) < 1)
    {
        scribble_tw_skip(element);
    }
    else if (!scribble_page_on_last(element))
    {
        scribble_page_set(element, 1 + scribble_page_get(element));
        scribble_tw_fade_in(element, SCRIBBLE_TW_PER_CHARACTER, 1, 10);
    }
    else
    {
        //Loop back round to the first page
        scribble_page_set(element, 0);
        scribble_tw_fade_in(element, SCRIBBLE_TW_PER_CHARACTER, 1, 10);
    }
}