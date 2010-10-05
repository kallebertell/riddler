class GamesController < ApplicationController
  def new
    render :text => "You are logged in as #{current_user.nil? ? 'no one' : current_user.name}."
  end
end
