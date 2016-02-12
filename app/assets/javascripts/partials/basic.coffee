$ ->
  $(".full_text_height").full_text_height()
  $(".content").contentMarginTop()

  $(window).resize ->
    $(".full_text_height").full_text_height()
    $(".content").contentMarginTop()
