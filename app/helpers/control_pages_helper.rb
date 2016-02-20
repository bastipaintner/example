module ControlPagesHelper
  # ermittlet ob ein Zug online ist
  def online? train_id
    $redis.exists train_id
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
