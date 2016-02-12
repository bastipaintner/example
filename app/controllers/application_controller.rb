class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_filter :logged_in_user

  protected
    # eingeloggter Nutzer
    def logged_in_user
      unless logged_in?
        store_location
        redirect_to login_url
      end
    end

    # ausgeloggter Nutzer
    def logged_out_user
      if admin? # Administrator?
        redirect_to administration_url
      elsif logged_in? # Angemeldet?
        redirect_to root_url
      end
    end

    # Administrator
    def admin_user
      unless admin?
        flash.now[:danger] = "Sie sind nicht berechtigt zu dieser Aktion!"
        redirect_to root_url
      end
    end

    # Leitwarte
    def leitwarten_user
      unless leitwarte?
        flash.now[:danger] = "Sie sind nicht berechtigt zu dieser Aktion!"
        redirect_to administration_url
      end
    end

    # Prüft ob ein Zug online ist
    def online? train_id
      begin
        trains = $redis.get "trains_online" # Liste von Online-Zügen
      rescue
        logger.error "No redis connection!\r\n" # Verbindugsprobleme zu Redis
      end

      if !trains.blank? # Ist die Variable nicht leer?
        trains = trains.split %r{,\s*} # Züge in Array laden
        trains.include? train_id.to_s # Überprügen ob gesuchter Zug dabei
      else
        false
      end
    end
end
