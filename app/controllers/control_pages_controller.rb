################################################################################
# controller for control_pages (stream-page and train-page)                    #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/control_pages_controller.rb                            #
################################################################################
class ControlPagesController < ApplicationController
  before_filter :leitwarten_user # only accessible for "Leitwarte"
  def index
    @trains = Train.all
    @num = 1
    @numOfTrains = @trains.count
    @numOfColumns = Math.sqrt(1.6 * @numOfTrains).floor
    @numOfRows = (@numOfTrains / @numOfColumns).ceil
    @numOfEmptyBoxes = @numOfColumns - (@numOfTrains - @numOfColumns*@numOfRows)
  end

  def show
    @train = Train.find_by_name params[:id]
    @time = params[:time].blank? ? getStreamTime : params[:time]

    redirect_to stored_page if stream_req? && train_offline?
    redirect_to prev_next_page params[:pn] if pn_req?

    @mode = stream_req? ? "stream" : "stored"

    @control = { prev: getPrevLinkData, next: getNextLinkData,
      p_p: getPlayPauseData, time: getTimeField }
  end

  private
    @@zero_time = "00000000000000"

    def stream_req?
      params[:time].nil?
    end

    def train_offline?
      !online? @train.id
    end

    def pn_req?
      !params[:pn].blank?
    end

    def getStreamTime
      begin
        time = $redis.get "time_stream"
      rescue
        logger.error "No redis connection!\r\n"
      end
      time.nil? ? @@zero_time : time
    end

    def stored_page
      img_time = Image.find_by_train_id @train.id
      time = img_time.nil? ? @@zero_time : img_time.time_stamp
      File.join "/zug", @train.name, time
    end

    def prev_next_page pn
      gl = pn == "prev" ? "<" : ">"
      order = pn == "prev" ? "DESC" : "ASC"
      img_time = Image.where("time_stamp #{gl} :time AND train_id = :train_id",
        {time: @time,
        train_id: @train.id}).reorder("time_stamp #{order}").limit(1).take
      time = img_time.nil? ? @time : img_time.time_stamp
      File.join "/zug", @train.name, time
    end

    def getPrevLinkData
      img = Image.where("train_id = :id", {id: @train.id}).last
      prev_1 = img.nil? ? false : (img.time_stamp < @time)
      prev_2 = @mode == "stream" ? false : true
      prev = prev_1 && prev_2 ? true : false
      path = File.join "/zug", @train.name, @time.to_s + "?pn=prev"
      path = "" if !prev
      style = "faded_out" if !prev
      id = "prev-#{@train.id}"
      {href: path, options: {id: id, remote: true, class: "prev #{style}"}}
    end

    def getNextLinkData
      img = Image.where("train_id = :id", {id: @train.id}).first
      next_1 = img.nil? ? false : (img.time_stamp > @time)
      next_2 = (@time < getStreamTime || getStreamTime == @@zero_time)
      next_2 = false if @mode == "stream"
      nex_t = next_1 && next_2 ? true : false
      path = File.join "/zug", @train.name, @time.to_s + "?pn=next"
      path = "" if !nex_t
      style = "faded_out" if !nex_t
      id = "next-#{@train.id}"
      {href: path, options: {id: id, remote: true, class: "next #{style}"}}
    end

    def getPlayPauseData
      base_path = "/zug/#{@train.name}"
      value = @mode == "stored" ? "P" : "S"
      id = @mode == "stored" ? "pause-#{@train.id}" : "pause-#{@train.id}"
      path = @mode == "stored" ? base_path : File.join(base_path, @time)
      path = "" if !online?(@train.id) && !(@mode == "stream")
      style = "faded_out" if !online?(@train.id) && !(@mode == "stream")
      {href: path, value: value, options: {id: id, class: "p_p #{style}"}}
    end

    def getTimeField
      zero_time_readable = "0000.00.00 00:00:00"
      if !(@time == @@zero_time)
        begin
          time = DateTime.strptime @time, "%Y%m%d%H%M%S"
          time = time.strftime "%d.%m.%Y %H:%M:%S"
        rescue ArgumentError
          time = zero_time_readable
        end
      else
        time = zero_time_readable
      end
      {value: time, id: "time-#{@mode}-#{@train.id}"}
    end

  end
