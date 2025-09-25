class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  before_action :require_organizer, only: [:new, :create, :edit, :update, :destroy]

  def index
    @matches = Match.upcoming.includes(:created_by, :participants).order(:date, :time)
  end

  def show
    @participation = current_user.participations.find_by(match: @match)
    @confirmed_participants = @match.confirmed_participants
    @declined_participants = @match.declined_participants
  end

  def new
    @match = current_user.created_matches.build
  end

  def create
    @match = current_user.created_matches.build(match_params)
    if @match.save
      flash[:notice] = "Match created successfully!"
      redirect_to @match
    else
      render :new
    end               
  end

  def edit
    redirect_to matches_path unless @match.created_by == current_user
  end

  def update
    if @match.created_by == current_user && @match.update(match_params)
      flash[:notice] = "Match updated successfully!"
      redirect_to @match
    else
      render :edit
    end
  end

  def destroy
    if @match.created_by == current_user
      @match.destroy
      flash[:notice] = "Match deleted successfully!"
    else
      flash[:alert] = "You can only delete your own matches"
    end
    redirect_to matches_path
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:title, :description, :date, :time, :location)
  end

  def require_organizer
    unless current_user.organizer?
      flash[:alert] = "Only organizers can manage matches"
      redirect_to matches_path
    end
  end
end
