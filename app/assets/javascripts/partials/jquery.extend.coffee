################################################################################
# extends jQuery                                                               #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/assets/javascripts/partials/jquery.extend.coffee                   #
################################################################################
jQuery.fn.extend
  # change text size of train boxes depending on window size
  full_text_height: () ->
    p_height = @parent().height()
    p_width = @parent().width()
    font_size = if p_height/2.5 >= 14 then p_height/2.5 else 14
    font_size = if p_width < p_height/2.5 then 14 else font_size
    @css "font-size", font_size

  # set padding for header and footer depending on their height
  contentPadding: () ->
    h_height = $("header").height()
    f_height = $(".footer").height()
    @css "padding-top", h_height + 4
    @css "padding-bottom", f_height + 4
