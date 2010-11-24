class ChoicesController < ApplicationController


  def select
    question = Question.find(params[:question_id])  
    choice = Choice.find(params[:id])
    
    choice.selected = true
    choice.save
    
    if (question.correct_choice.id == choice.id)
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect. Should've been "+question.correct_choice.text
    end

    redirect_to url_for(Game.find(params[:game_id]))
  end
  
  
end
