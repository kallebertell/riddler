class QuestionsController < ApplicationController

  def new
    @game = session[:game]

    if (!@game)
      redirect_to_target_or_default(root_url)
    end

    question_factory = QuestionFactory.new(@fb_session, @game)
     

    @game.round_count += 1

    @question = question_factory.create_random_question
    @question.save
    
    @game.questions << @question
    @game.save    
    
    session[:correct_choice] = @question.correct_choice
  end

  def answer
    if (params[:answer].to_s == session[:correct_choice].key.to_s)
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect. Should've been "+session[:correct_choice].text
    end

    redirect_to :new_question
  end

end
