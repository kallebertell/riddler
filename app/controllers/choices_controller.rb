class ChoicesController < ApplicationController


  def select
    if (params[:id] == session[:correct_choice].id)
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect. Should've been "+session[:correct_choice].text
    end

    redirect_to url_for(Game.find(params[:game_id]))
  end
  
  
end
