class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :current_user
  before_action :require_login

  private

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      # Wenn der Benutzer nicht gefunden wurde, Session zurücksetzen
      session.delete(:user_id) unless @current_user
    end
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end

  def skip_require_login
    skip_before_action :require_login
  end

  helper_method :current_user, :logged_in?
end
