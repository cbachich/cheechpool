class SmacksController < ApplicationController
  before_filter :signed_in_user

  def create
    @smack = current_user.smacks.build(params[:smack])
    @smack.league_id = active_league.id
    if !@smack.save
      flash[:error] = "Smack couldn't be posted!"
    end
    redirect_to root_path
  end

  def destroy
  end
end
