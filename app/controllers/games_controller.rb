class GamesController < ApplicationController
  def new
    render :text => current_user.nil?
  end
end
