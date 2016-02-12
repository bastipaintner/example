class StaticPagesController < ApplicationController
  # include ActionController::Live
  before_filter :admin_user, only: [:administration]
  def help
  end

  def about
  end

  def administration # nur für Administrator
    @trains = Train.all
    @users = User.all
    @traintypes = Traintype.all
    @images = Image.all
  end

  def test

  end
end
