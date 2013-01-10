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
      redirect_to @league
    else
      render 'new'
    end
  end
end
