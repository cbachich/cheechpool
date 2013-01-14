class LeaguesController < ApplicationController
  
  def show
    @league = League.find(params[:id])
    @smacks = @league.smacks.paginate(page: params[:page])
    @league_user = LeagueUser.find_by_user_id_and_league_id(current_user.id, @league.id)
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    if @league.save
      flash[:success] = "League created!"
      LeagueUser.create(league_id: @league.id, user_id: current_user.id, admin: true)
      redirect_to @league
    else
      render 'new'
    end
  end

  def index
    @leagues = League.paginate(page: params[:page])
  end

  def add_user
    @league = League.find(params[:id])
    if LeagueUser.exists?(user_id: current_user.id, league_id: @league.id)
      flash[:error] = "User already joined in this league!"
    else
      LeagueUser.create(league_id: @league.id, user_id: current_user.id)
      flash[:success] = "Joined this league!"
    end
    redirect_to @league
  end

  def remove_user
    @league = League.find(params[:id])
    LeagueUser.find_by_user_id_and_league_id(current_user.id, @league.id).destroy
    flash[:success] = "Quit this league!"
    redirect_to @league
  end
end
