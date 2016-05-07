################################################################################
# general controller for the application                                       #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/application_controller.rb                              #
################################################################################
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_filter :logged_in_user # requires login for all pages

  protected
    def logged_in_user
      unless logged_in?
        store_location
        redirect_to login_url
      end
    end

    def logged_out_user
      if admin?
        redirect_to administration_url
      elsif logged_in?
        redirect_to root_url
      end
    end

    def admin_user
      unless admin?
        flash.now[:danger] = "Sie sind nicht berechtigt zu dieser Aktion!"
        redirect_to root_url
      end
    end

    def leitwarten_user
      unless leitwarte?
        flash.now[:danger] = "Sie sind nicht berechtigt zu dieser Aktion!"
        redirect_to administration_url
      end
    end

    # is a train online?
    def online? train_id
      $redis.exists train_id
    end
end
