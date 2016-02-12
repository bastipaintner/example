class ImagesController < ApplicationController
  skip_before_action :logged_in_user, only: :create
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    time_f = "%Y%m%d%H%M%S"
    time_r_f = "%d.%m.%Y %H:%M:%S"

    cam_ip = request.remote_ip # development
    # cam_ip = env["HTTP_X_FORWARDED_FOR"] # Bestimmung der ursprungs IP

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
      if numOfImages >= 1000
        num = numOfImages - 1000
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

      if !$redis.hexists stream_hash, @train.id
        $redis.hset stream_hash, @train.id, @train.name
      end

      if !$redis.hexists stream_hash, "time_stamp"
        $redis.hset stream_hash, "time_stamp", @time
      end

      if !$redis.hexists stream_hash, "time_readable"
        $redis.hset stream_hash, "time_readable", @time_readable
      end
    end

    def getTimeStamp disposition
      time = disposition.match(/^attachment; filename=\"(?<name>.*)\"/)[:name]
      time = Time.now.strftime "%Y%m%d%H%M%S" if time.blank?
      time = time.to_i
      (time - (time % 2)).to_s
    end
end
