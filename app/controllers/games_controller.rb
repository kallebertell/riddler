class GamesController < ApplicationController

  def new
    game = session[:game] = Game.new
    game.round_count = 0
    game.save
    redirect_to :new_question
  end

end
