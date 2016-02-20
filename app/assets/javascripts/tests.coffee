$ ->
  if $(".test_img").length != 0
    setInterval streamImages, 2000

streamImages = () ->
  time = new Date().getTime().toString 10
  base_path = "/axis-cgi/jpg/image.cgi?resolution=800x600&bla=#{time}"
  base_url = "http://192.168.178.32"
  $(".test_img").each (i, img) ->
    # url = base_url + "" + (i+1)
    path = base_url + base_path
    $(this).attr "src", path
