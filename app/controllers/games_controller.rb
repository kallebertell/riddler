class GamesController < ApplicationController

  def new
    @game = session[:game] = Game.new
  end

  def create
    @game = session[:game];
    @game.round_count = 0
    @game.save
    redirect_to @game
  end
  
  def show
    @game = Game.find(params[:id])
  end
  
end
