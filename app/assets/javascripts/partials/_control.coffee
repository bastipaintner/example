# Funktionen für control_pages
$ ->
  # Einbinden der Tastatur
  $(document).keydown (e) ->
    switch e.keyCode
      when 32 then p_p() # space
      when 37 then prev() # left arrow
      when 39 then next() # right arrow

prev = ->
  href = $(".prev").attr "href"
  if href != ""
    $(".prev").click()
    loading()

p_p = ->
  href = $(".p_p").attr "href"
  if href != ""
    location.href = href

next = ->
  href = $(".next").attr "href"
  if href != ""
    $(".next").click()
    loading()

loading = ->
  if !$(".stored").hasClass "loaded"
    setTimeout ->
      if $(".stored").hasClass "loaded"
        $(".stored").removeClass "loaded"
      else
        $(".stored").children(".loading").css "display", "inline-block"
    , 500
