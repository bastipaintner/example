class ControlPagesController < ApplicationController
  before_filter :leitwarten_user
  def index
    @trains = Train.all
    @num = 1
    @numOfTrains = @trains.count
    @numOfRows = (@numOfTrains / 10).ceil
    @numOfEmptyRows = @numOfRows - (@numOfTrains - 10 * @numOfRows)
  end

  def show
    @train = checkTrain params[:id]
    @time = params[:time].blank? ? getLatestImgTime @train.id : params[:time]

    redirect_to getImgLink @train.name, @time if stream_req? && train_offline?
    redirect_to getPNImgLink @train, @time, params[:pn] if pn_req?

    @mode = stream_req? ? "stream" : "stored"
    @images = getImages @train.id, @mode, @time

    @control = {
      prev: getPrevNextImgData("prev", @time, @train, @mode),
      next: getPrevNextImgData("next", @time, @train, @mode),
      p_p: getPlayPauseData(@mode, @time, @train),
      time: getTimeField(@time, @train.id, @mode)
    }

    private
      @@zero_time = "00000000000000"
      @@base_path = "/zug/#{params[:id]}"

      def stream_req?
        params[:time].nil?
      end

      def pn_req?
        !params[:pn].blank?
      end

      def checkTrain train_name
        Train.find_by name: train_name
      end

      def getLatestImgTime train_id
        img = Image.find_by_train_id train_id
        img.nil? ? @@zero_time : img.time_stamp
      end

      def getImgLink train_name, time
        File.join @@base_path, time
      end

      def getPNImgLink train, time, pn
        gl = pn == "prev" ? "<" : ">"
        order = pn == "prev" ? "DESC" : "ASC"
        img = Image.where("time_stamp :gl :time AND train_id = :train_id",
          {time: time, gl: gl,
          train_id: train.id}).reorder("time_stamp #{order}").limit(1).take
        new_time = img.nil? time, img.time_stamp
        getImgLink train.name, new_time
      end

      def getImages train_id, mode, time
        images = Image.find_by train_id: train_id, time_stamp: time
        data = Hash.new
        images.each do |img|
          data[img.cam_num] = { path: img.path,
            id: "cam-#{@train.id}-#{img.cam_num}", class: mode }
        end

        for i in 1..8 do
          data[i] = { path: "/no_data.png", id: "cam-#{@train.id}-#{i}",
            class: mode } if data[i].blank?
        end
        data
      end

      def getPrevNextImgData pn, time, train, mode
        gl = pn == "prev" ? "<" : ">"
        order = pn == "prev" ? "DESC" : "ASC"
        next_q = pn == "next" ? (getStreamTime() >= time.to_i) : false
        prev_q = pn == "prev"
        data_stored_q = !(time == @@zero_time) && mode == "stored"
        if data_stored_q && (next_q || prev_q)
          img = Image.where("time_stamp :gl :time AND train_id = :train_id",
            {time: time, gl: gl,
            train_id: train.id}).reorder("time_stamp #{order}").limit(1).take
        end
        visibility = !img.nil? "visible" : "hidden"
        path = File.join @@base_path, time.to_s + "?pn=" + pn
        id = "#{prev_next}-#{train.id}"
        style = "visibility:#{visibility};"
        {href: path, visibility: visibility, options: {id: id, style: style,
          remote: true, class: pn}}
      end

      def getPlayPauseData mode, time, train
        value = mode == "stored" ? "P" : "S"
        id = mode == "stored" ? "pause-#{train.id}" : "pause-#{train.id}"
        path = mode == "stored" ? @@base_path : File.join @@base_path, time
        visibility = online?(train.id) ? "visible" : "hidden"
        visibility = "visible" if mode == "stored"
        style = "visibility:#{visibility};"
        {href: path, value: value, options: {id: id, style: style,
          class: "p_p"}}
      end

      def getTimeField time, train_id, mode
        zero_time_readable = "0000.00.00 00:00:00"
        if !(time == @@zero_time)
          begin
            time = DateTime.strptime time, "%Y%m%d%H%M%S"
            time = time.strftime "%d.%m.%Y %H:%M:%S"
          rescue ArgumentError
            time = zero_time_readable
          end
        else
          time = zero_time_readable
        end
        {value: time, id: "time-#{mode}-#{train_id}"}
      end
  end
