class QuestionsController < ApplicationController

  def show
    @game = Game.find(params[:game_id])
    @question = Question.find(params[:id])        
  end

  private

  def find_parent_resources
    @game = current_user.games.find(params[:game_id])
  end

end
