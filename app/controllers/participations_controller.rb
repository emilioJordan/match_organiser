class ParticipationsController < ApplicationController
  before_action :set_match

  def create
    # Suche nach einer existierenden Teilnahme
    @participation = @match.participations.find_by(user: current_user)
    
    if @participation
      # Aktualisiere die bestehende Teilnahme
      if @participation.update(status: params[:status])
        flash[:notice] = "Your participation has been updated!"
      else
        flash[:alert] = "Something went wrong. Please try again."
      end
    else
      # Erstelle eine neue Teilnahme
      @participation = @match.participations.build(user: current_user, status: params[:status])
      if @participation.save
        flash[:notice] = "Your participation has been recorded!"
      else
        flash[:alert] = "Something went wrong. Please try again."
      end
    end
    
    redirect_to @match
  end

  def update
    @participation = @match.participations.find_by(user: current_user)
    
    if @participation && @participation.update(status: params[:status])
      flash[:notice] = "Your participation has been updated!"
    else
      flash[:alert] = "Something went wrong. Please try again."
    end
    
    redirect_to @match
  end

  def destroy
    @participation = @match.participations.find_by(user: current_user)
    
    if @participation&.destroy
      flash[:notice] = "You have been removed from this match."
    else
      flash[:alert] = "Something went wrong. Please try again."
    end
    
    redirect_to @match
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end
end
