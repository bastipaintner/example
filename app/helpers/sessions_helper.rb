################################################################################
# helper for sessions                                                          #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/helpers/application_helper.rb                                      #
################################################################################
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    current_user.admin if logged_in?
  end

  def leitwarte?
    !current_user.admin if logged_in?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
