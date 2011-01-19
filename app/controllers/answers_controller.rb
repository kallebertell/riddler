class AnswersController < ApplicationController
  before_filter :find_parent_resources



  def create
    @question.answer!(params[:choice_id])
    
    if @question.answered_correctly?
      flash[:correct] = "Correct!"
    elsif @question.answered_late?
      flash[:incorrect] = "You were too late!"
    else
      flash[:incorrect] = "Incorrect!"
    end

    # reload game since answering it may change its state
    @game.reload()
   
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
