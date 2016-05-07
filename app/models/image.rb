################################################################################
# model for images                                                             #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/models/image.rb                                                    #
################################################################################
class Image < ActiveRecord::Base
  belongs_to :train
  validates :time_stamp, presence: true
  validates :train_id, presence: true
  default_scope -> { order(created_at: :desc) }
  before_destroy :delete_files

  def delete_files
    for i in 1..8
      root = "#{Rails.root}/public/uploads/image"
      path = "#{root}/#{self.train_id}/#{i}/#{self.time_stamp}.jpg"
      begin
        File.delete path if File.file? path
      rescue
        logger.error "Error deleting file: '#{path}'"
      end
    end
  end
end
