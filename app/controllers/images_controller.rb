################################################################################
# controller for uploading and showing images                                  #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/images_controller.rb                                   #
################################################################################
class ImagesController < ApplicationController
  skip_before_action :logged_in_user, only: :create # to create an image you
    # dont't have to be logged in
  skip_before_filter :verify_authenticity_token, only: :create # to create an
    # image you dont't have to have an authenticity token

  def create
    time_f = "%Y%m%d%H%M%S"
    time_r_f = "%d.%m.%Y %H:%M:%S"

    cam_ip = request.remote_ip if !Rails.env.production?
    cam_ip = env["HTTP_X_FORWARDED_FOR"] if Rails.env.production?

    if cam_ip == "192.168.178.22"
      @cam_num = 1
      train_ip = ""
      @train =  Train.find_by name: "997"
    elsif cam_ip == "192.168.178.32"
      @cam_num = 1
      train_ip = ""
      @train =  Train.find_by name: "998"
    else
      @cam_num = cam_ip[/\d*$/]
      train_ip = cam_ip.sub(/\.\d*$/, '')
      @train = Train.find_by ip_address: train_ip
    end

    @time = getTimeStamp request.env['HTTP_CONTENT_DISPOSITION']
    @time_readable = Time.strptime(@time, time_f).strftime time_r_f
    file_name = @time + ".jpg"

    saveImage request.body.read
    Image.where(train_id: @train.id, time_stamp: @time).first_or_create
    pushImages
    deleteImages
    render text: "Upload OK\r\n"
    log_images
    #logger.info "--------------------------------------------------------------"
    #logger.info "Time: #{@cam_time}, Milli: #{@cam_milli}"
  end

  def show
    train_id = check_param params[:id]
    cam_num = check_param params[:num]
    time = check_param params[:time]
    root = "#{Rails.root}/public"
    img_path = "#{root}/uploads/image/#{train_id}/#{cam_num}/#{time}.jpg"
    dflt_path = "#{root}/no_data.png"

    if File.file? img_path
      send_file img_path, type: 'image/jpg', disposition: 'inline'
    else
      send_file dflt_path, type: 'image/png', disposition: 'inline'
    end
  end

  private
    def getStreamTime
      begin
        time = $redis.get "time_stream"
      rescue
        logger.error "No redis connection!\r\n"
      end
      time = time.nil? ? @@zero_time : time
      Time.strptime(time, "%Y%m%d%H%M%S").strftime "%d.%m.%Y %H:%M:%S"
    end

    def check_param param
      param.is_i? ? param : 0
    end

    def saveImage image_data
      upload_dir = "public/uploads/image/#{@train.id}/#{@cam_num}"
      file_name = @time + ".jpg"
      path = File.join upload_dir, file_name

      FileUtils.mkdir_p upload_dir if !Dir.exist? upload_dir
      File.open(path, "wb") { |f| f.write image_data }
    end

    def deleteImages
      imgs = Image.where "train_id = :train_id", { train_id: @train.id }
      numOfImages = imgs.count
      logger.debug "Num of Images: " + numOfImages.to_s
      if numOfImages >= 1000
        num = numOfImages - 1000
        logger.debug "Number of images too much: #{num}"
        imgs.reorder("time_stamp ASC").take(num).each do |img|
          begin
            img.destroy
          rescue
            logger.error "SQL:BUSY"
          end
        end
      end
    end

    def pushImages
      stream_hash = "stream_#{@time}"

      logger.info "Redis: "

      if !$redis.hexists stream_hash, @train.id
        logger.info "Redis set: " + $redis.hset(stream_hash, @train.id, @train.name).to_s
      end

      if !$redis.hexists stream_hash, "time_stamp"
        $redis.hset stream_hash, "time_stamp", @time
      end

      if !$redis.hexists stream_hash, "time_readable"
        $redis.hset stream_hash, "time_readable", @time_readable
      end
    end

    def getTimeStamp disposition
      time = disposition.match(/^attachment; filename=\"(?<time>.*)\"/)[:time]
      time, time_milli = time.split /,/
      @time_arr = Time.now.strftime "%d.%m.%Y %H:%M:%S"
      time = Time.now.strftime "%Y%m%d%H%M%S" if time.blank?
      @time_img = Time.strptime(time, "%Y%m%d%H%M%S").strftime "%d.%m.%Y %H:%M:%S"
      @time_img = @time_img + " h:#{time_milli}"
      time = time.to_i
      time_milli = time_milli.blank? ? 0 :  time_milli.to_i
      path = "#{Rails.root}/public/uploads/image/#{@train.id}/#{@cam_num}"
      file_path = File.join path, ((time - (time % 2)).to_s + ".jpg")
      if File.file? file_path
        @dub = "yes"
        (time + (time % 2)).to_s
      else
        @dub = ""
        (time - (time % 2)).to_s
      end
    end

    def log_images
      path = "#{Rails.root}/log/test.log"
      log = "Train: #{@train.name}, Time Img: #{@time_img}, Time Img New: #{@time_readable}, Time Arrived: #{@time_arr}, Time Server: #{getStreamTime}, Cam Num: #{@cam_num}, Double: #{@dub}"
      File.open(path, "a") { |f| f.puts log }
    end
end
