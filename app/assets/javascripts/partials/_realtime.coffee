################################################################################
# functions for realtime                                                       #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/assets/javascripts/partials/_realtime.coffee                       #
################################################################################
$ ->
  if !@socket
    @socket = io.connect() # "http://0.0.0.0:5001" # for development

    # channel "stream"
    @socket.on "stream", (msg) ->
      msg = if msg == null then {} else msg
      stream msg

    # channel "online"
    @socket.on "online", (msg) ->
      train = if msg == null then "" else msg
      setStatus msg, 1

    # channel "offline"
    @socket.on "offline", (msg) ->
      train = if msg == null then "" else msg
      setStatus msg, 0

  # change status of trains and change buttons
  setStatus = (train_id, status) ->
    train = $("#train_#{train_id}").children "a"
    patt = /\d+/
    play_pause = $(".p_p")
    id = patt.exec play_pause.attr("id")

    if parseInt(id) == parseInt(train_id)
      if $("#stream").length != 0 && status == 0
        train_name = $("#stream").data "train"
        location.href = "/zug/#{train_name}"
      else if $("#stored").length != 0
        if status
          $("#control_status").text ""
          if play_pause.hasClass "faded_out"
            train_name = $("#stored").data "train"
            play_pause.removeClass("faded_out").attr "href", "/zug/#{train_name}"
        else
          $("#control_status").text "(offline)"
          if !play_pause.hasClass "faded_out"
            play_pause.addClass("faded_out").attr "href", ""

    else if train.length != 0
      if status
        train.removeClass "train_offline" if train.hasClass "train_offline"
      else
        train.addClass "train_offline" if !train.hasClass "train_offline"

  # change live images, play_pause button and next button
  stream = (msg) ->
    patt = /\d+/
    images = $(".stream_element")
    play_pause = $(".p_p")
    id = patt.exec play_pause.attr("id")
    next = $(".next")

    if typeof msg[id] != "undefined"
      if $("#stream").length != 0
        $(".time").text msg["time_readable"]
        href = "/zug/#{msg[id]}/#{msg["time_stamp"]}"
        play_pause.attr "href", href
        for i in [1..8]
          src = "/images/#{id}/#{i}/#{msg["time_stamp"]}"
          $("#cam-#{id}-#{i}").attr "src", src
      else if $("#stored").length != 0 && next.attr("href") == ""
        next.removeClass "faded_out" if next.hasClass "faded_out"
        next.attr "href", "/zug/#{msg[id]}/?pn=next"
