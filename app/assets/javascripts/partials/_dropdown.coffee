$ ->
  $("div[data-toggle]").hover ->
    toggle = $(this).data("toggle")
    target = $(this).data("target")
    switch toggle
      when "dropdown" then $(target).toggle()
