class SessionsController < ApplicationController
  # kein Login für Aktion new und create
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :logged_out_user, only: [:new, :create]
  def new
  end

  def create
    # suche Nutzer anhand des login Namens
    user = User.find_by(name: params[:session][:login_name].downcase.capitalize)
    # wenn login Name und Passwort passen
    if user && user.authenticate(params[:session][:login_password])
      log_in user # Nutzer einloggen
      # wenn Nutzer Admin, dann zu Administrator-Seite, sonst zu Root
      redirect_back_or admin? ? administration_url : root_url
    # wenn Name oder Passwort nicht passt
    else
      flash.now[:danger] = 'Falscher Nutzername oder Passwort' # Warnhinweis
      render 'new' # wieder zum Login zurück
    end
  end

  def destroy
    log_out if logged_in? # Nutzer ausloggen, wenn er eingeloggt ist
    redirect_to login_url # zurück um Login
  end

  private
    def authenticate(login_password = "") # Passwortüberprüfung
      encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
    end
end
