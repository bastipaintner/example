# Funktionen für control_pages
$ ->
  # Einbinden der Tastatur
  $(document).keydown (e) ->
    switch e.keyCode
      when 32 then p_p() # space
      when 37 then prev() # left arrow
      when 39 then next() # right arrow

  $(".stream_img").load ->
    $(".loading").css "display", "none"
    $(".stored").addClass "loaded"
    setTimeout ->
      $(".loading").css "display", "none"
      $(".stored").removeClass "loaded"
    , 1000


prev = ->
  href = $(".prev").attr "href"
  if href != ""
    loading()
    $(".prev").click()

p_p = ->
  href = $(".p_p").attr "href"
  if href != ""
    location.href = href

next = ->
  href = $(".next").attr "href"
  if href != ""
    loading()
    $(".next").click()

loading = ->
  setTimeout ->
    if !$(".stored").hasClass "loaded"
      $(".stored").children(".loading").css "display", "inline-block"
    else
      $(".stored").removeClass("loaded")
  , 1000
