class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @leagues = @user.leagues.paginate(page: params[:page])
    @smacks = @user.smacks.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to CheechPool!"
      redirect_to leagues_path 
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = active_league.users.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def set_active_league
    user = User.find(params[:id])
    league_id = params[:league_id].to_i
    if user.active_league_id != league_id
      user.active_league_id = league_id
      if user.save
        league_name = League.find(user.active_league_id).name
        flash[:success] = "Switched to #{league_name}"
      else
        flash[:error] = "Unable to switch leagues!"
      end
    end
    redirect_to "/leagues/#{user.active_league_id}"
  end

  def admin
  end

  def reset
  end

  def reset_password
    user = User.find_by_email(params[:email].downcase)
    if user.nil?
      flash[:error] = "Email was not found."
    else
      user.reset_password
      flash[:success] = "New password was sent to your email address."
    end
    redirect_to reset_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
