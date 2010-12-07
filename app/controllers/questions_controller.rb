class QuestionsController < ApplicationController
  before_filter :find_parent_resources

  def show
    @question = @game.questions.find(params[:id])        
  end

  private

  def find_parent_resources
    @game = current_user.games.find(params[:game_id])
  end

end
