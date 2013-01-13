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
    redirect_to @league
  end
end
