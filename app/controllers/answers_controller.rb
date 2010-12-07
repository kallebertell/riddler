class AnswersController < ApplicationController
  before_filter :find_parent_resources

  def create
    @question.answer!(params[:choice_id])
    
    if @question.answered_correctly?
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect!"
    end

    if @game.rounds_left?
      redirect_to [@game,@game.questions.create]
    else
      redirect_to(@game)
    end
  end

  private

  def find_parent_resources
    @game = current_user.games.find(params[:game_id])
    @question = @game.questions.find(params[:question_id])
  end
end
