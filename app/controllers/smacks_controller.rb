class SmacksController < ApplicationController
  before_filter :signed_in_user

  def create
    @smack = current_user.smacks.build(params[:smack])
    if @smack.save
      flash[:success] = "Smack Talk posted!"
      redirect_to root_path
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
end
