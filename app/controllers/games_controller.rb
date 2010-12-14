class GamesController < ApplicationController

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @game = current_user.games.create(:round_count => 10, :facebook_data => @fb_session.fetch_game_data)
      redirect_to [@game,@game.questions.create]
    end
  end
  
  def show
    @game = current_user.games.find(params[:id])
  end
  
  
end
