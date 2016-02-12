module ControlPagesHelper
  # ermittlet ob ein Zug online ist
  def online? train_id
    begin
      trains = $redis.get "trains_online" # lädt Liste mit online Zügen
    rescue # bei Fehler
      logger.error "No redis connection!\r\n"
    end

    if !trains.blank? # wenn Züge gefunden
      trains = trains.split %r{,\s*}  # in Array laden
      trains.include? train_id.to_s   # bestimmten ob der Gesuchte dabei ist
    else
      false
    end
  end

  def getClass train_id
    online?(train_id) ? "" : "train_offline"
  end

  def getImgPath cam_num
    "/images/#{@train.id}/#{cam_num}/#{@time}"
  end

  def getImgId cam_num
    "cam-#{@train.id}-#{cam_num}"
  end
end
