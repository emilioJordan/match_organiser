class ActivitiesController < ApplicationController
  def index
    @activities = PaperTrail::Version.includes(:item)
                                   .order(created_at: :desc)
                                   .limit(50)
  end
end