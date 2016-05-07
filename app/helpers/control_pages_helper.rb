################################################################################
# helper for control pages                                                     #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/helpers/control_pages_helper.rb                                    #
################################################################################
module ControlPagesHelper
  # is a train online?
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
