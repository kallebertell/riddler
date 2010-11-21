class QuestionsController < ApplicationController
  
  def create
    @game = Game.find(params[:game_id])
    
    if (!@game)
      redirect_to_target_or_default(root_url)
    end

    question_factory = QuestionFactory.new(@fb_session, @game)

    @game.round_count += 1

    @question = question_factory.create_random_question
    @question.save
    @game.save    
    
    session[:correct_choice] = @question.correct_choice
    
    redirect_to :action => 'show', :id => @question.id
  end

  def show
    @game = Game.find(params[:game_id])
    @question = Question.find(params[:id])        
  end


end
