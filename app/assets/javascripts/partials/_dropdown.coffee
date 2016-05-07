################################################################################
# functions for dropdown elements                                              #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/assets/javascripts/partials/_dropdown.coffee                       #
################################################################################
$ ->
  $("div[data-toggle]").hover ->
    toggle = $(this).data("toggle")
    target = $(this).data("target")
    switch toggle
      when "dropdown" then $(target).toggle()
