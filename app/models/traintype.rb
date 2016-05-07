################################################################################
# model for traintypes                                                         #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/models/traintype.rb                                                #
################################################################################
class Traintype < ActiveRecord::Base
  has_many :trains, dependent: :destroy
  default_scope -> { order(name: :asc) }
end
