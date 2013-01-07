class StaticPagesController < ApplicationController
  def home
    @smack = current_user.smacks.build if signed_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
