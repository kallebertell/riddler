class GamesController < ApplicationController

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @current_user.update_facebook_data(@fb_session)
    end    
    ActiveRecord::Base.transaction do
      @game = current_user.games.create(:round_count => 10, :wrong_answers => 0, :max_wrong_answers => 2)
      redirect_to [@game,@game.questions.create]
    end
  end
  
  def show
    @game = current_user.games.find(params[:id])
    
    @users = User.find_user_friends(current_user.id)
    @users << current_user
    
    @users.sort! { |a,b| b.alltime_score <=> a.alltime_score } 
  end
  
end
