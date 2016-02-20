jQuery.fn.extend
  full_text_height: () ->
    p_height = @parent().height()
    p_width = @parent().width()
    font_size = if p_height/2.5 >= 14 then p_height/2.5 else 14
    font_size = if p_width < p_height/2.5 then 14 else font_size
    @css "font-size", font_size

  contentMargin: () ->
    h_height = $("header").height()
    f_height = $(".footer").height()
    @css "padding-top", h_height + 4
    @css "padding-bottom", f_height + 4
