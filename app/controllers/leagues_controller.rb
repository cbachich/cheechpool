class LeaguesController < ApplicationController
  
  def show
    @league = League.find(params[:id])
    @smacks = @league.smacks.paginate(page: params[:page])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    if @league.save
      flash[:success] = "League created!"
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
    LeagueUser.create(league_id: @league.id, user_id: current_user.id)
    flash[:success] = "Joined this league!"
    redirect_to @league
  end

  def remove_user
    @league = League.find(params[:id])
    LeagueUser.find_by_user_id_and_league_id(current_user.id, @league.id).destroy
    flash[:success] = "Quit this league!"
    redirect_to @league
  end
end
