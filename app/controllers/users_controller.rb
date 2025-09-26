class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Account erfolgreich erstellt! Willkommen, #{@user.name}!"
        format.html { redirect_to root_path }
        format.turbo_stream { redirect_to root_path }
      else
        flash.now[:alert] = "Bitte korrigieren Sie die Fehler unten."
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
