################################################################################
# execute basic functions                                                      #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/assets/javascripts/partials/basic.coffee                           #
################################################################################
$ ->
  $(".full_text_height").full_text_height()
  $(".content").contentPadding()

  $(window).resize ->
    $(".full_text_height").full_text_height()
    $(".content").contentPadding()
