class Train < ActiveRecord::Base
  belongs_to :traintype
  has_many :images, dependent: :destroy
  before_save :get_ip_address
  validates :name, presence: true, length: { maximum: 3 }
  validates :traintype_id, presence: true
  default_scope -> { order(name: :asc) }

  private
    # Ermittelt Ip-Adresse der Kameras
    def get_ip_address
      # number_one = 192 + name.to_i / 32
      # number_two = 8 * (name.to_i % 32) + 6
      # self.ip_address = "10.36.#{number_one}.#{number_two}"

      # Zug 997:
      self.ip_address = "10.33.45" if name == "301"
      self.ip_address = "10.33.47" if name == "303"
      self.ip_address = "10.35.229" if name == "997"
    end
end
