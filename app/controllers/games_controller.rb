class GamesController < ApplicationController

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @current_user.update_facebook_data(@fb_session)
    end    
    ActiveRecord::Base.transaction do
      @game = current_user.games.create(
        :round_count => 10,
        :wrong_answers => 0,
        :max_wrong_answers => 2,
        :seconds_to_answer => 30)
      redirect_to [@game,@game.questions.create]
    end
  end
  
  def show
    @game = current_user.games.find(params[:id])
    
    @users = User.find_user_and_friends(current_user.id)
    
    @week_best_users = User.find_user_and_friends_ordered_by_week_score(current_user.id)
  end
  
end
