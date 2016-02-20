$ ->
  $(".full_text_height").full_text_height()
  $(".content").contentMargin()

  $(window).resize ->
    $(".full_text_height").full_text_height()
    $(".content").contentMargin()
