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
      self.ip_address = "10.33.45" if name == "301"
      self.ip_address = "10.33.47" if name == "303"
      self.ip_address = "10.35.229" if name == "997"
      self.ip_address = "10.33.56" if name == "312"
    end
end
