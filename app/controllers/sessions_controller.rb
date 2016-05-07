################################################################################
# controller for sessins                                                       #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/sessions_controller.rb                                 #
################################################################################
class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :logged_out_user, only: [:new, :create] # only logged_out_user
    # can logg in

  def new
  end

  def create
    user = User.find_by name: params[:session][:login_name].downcase.capitalize
    if user && user.authenticate(params[:session][:login_password])
      log_in user
      redirect_back_or admin? ? administration_url : root_url
    else
      flash.now[:danger] = 'Falscher Nutzername oder Passwort'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end

  private
    def authenticate login_password = ""
      encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
    end
end
