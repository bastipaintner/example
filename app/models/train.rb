################################################################################
# model for trains                                                             #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/models/train.rb                                                    #
################################################################################
class Train < ActiveRecord::Base
  belongs_to :traintype
  has_many :images, dependent: :destroy
  before_save :get_ip_address
  validates :name, presence: true, length: { maximum: 3 }
  validates :traintype_id, presence: true
  default_scope -> { order(name: :asc) }

  private
    def get_ip_address
      
    end
end
