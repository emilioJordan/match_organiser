class ActivitiesController < ApplicationController
  before_action :require_organizer

  def index
    @activities = PaperTrail::Version.includes(:item)
                                   .order(created_at: :desc)
                                   .limit(50)
  end

  private

  def require_organizer
    unless current_user&.organizer?
      flash[:alert] = "Nur Organisatoren haben Zugriff auf diese Seite"
      redirect_to root_path
    end
  end
end