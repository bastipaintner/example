module SessionsHelper

  # Loggt den übergebenen Nutzer ein
  def log_in(user)
    session[:user_id] = user.id
  end

  # Gibt den eingeloggten Nutzer zurück, wenn angemeldet.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # bestimmt ob ein Nutzer eingeloggt ist
  def logged_in?
    !current_user.nil?
  end

  # bestimmt ob ein Nutzer Administrator ist
  def admin?
    current_user.admin if logged_in?
  end

  # bestimmt ob ein Nutzer Leitwarte ist
  def leitwarte?
    !current_user.admin if logged_in?
  end

  # loggt einen Nutzer aus
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # leitet einen Nutzer nach dem Login an Root oder vorherige Adresse weiter
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # speichert verlangte Adresse
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
