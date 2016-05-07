################################################################################
# controller for static pages                                                  #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/static_pages_controller.rb                             #
################################################################################
class StaticPagesController < ApplicationController
  before_filter :admin_user, only: [:administration]
  def help
  end

  def about
  end

  def administration # only accessible for admin
    @trains = Train.all
    @users = User.all
    @traintypes = Traintype.all
    @images = Image.all
  end
end
