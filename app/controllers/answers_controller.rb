class AnswersController < ApplicationController
  before_filter :find_parent_resources

  def create
    @question.answer!(params[:choice_id])
    @game.reload
    if @game.rounds_left?
      @game.questions.create
    end
  rescue QuestionAlreadyAnswered
    logger.info("The user ID=#{current_user.id} tried to answer twice")
  ensure
    if @question.answered_late?
      flash[:incorrect] = "You were too late!"
    elsif @question.answered_correctly?
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect!"
    end

    if @question.id == @game.questions.last.id
      redirect_to(@game)
    else
      redirect_to [@game, @game.questions.last]
    end
  end

  private

  def find_parent_resources
    @game = current_user.games.find(params[:game_id])
    @question = @game.questions.find(params[:question_id])
  end
end
