class GamesController < ApplicationController

  def new
  end

  def create
    @game = current_user.games.create(:round_count => 10)
    cache_facebook_data_for_game
    redirect_to [@game,@game.questions.create]
  end
  
  def show
    @game = current_user.games.find(params[:id])
  end
  
  private 

  def cache_facebook_data_for_game
  
    data = @fb_session.get_friends_and_statuses()
    
    status_datas = data['statuses']
    friend_datas = data['friends']
  
    for status_data in status_datas
      msg = status_data['message']

      if (msg.length > 255) 
        msg = msg[0,253] + ".."
      end
    
      status = Status.new(:fb_user_id => status_data['uid'], 
                          :fb_status_id => status_data['status_id'],
                          :message => msg);
      @game.statuses << status
      status.save           
    end
    
    for friend_data in friend_datas
      friend = Friend.new(:fb_user_id => friend_data['uid'],
                          :name => friend_data['name'],
                          :pic_square_url => friend_data['pic_square'],
                          :birthday_date => friend_data['birthday_date']);

      @game.friends << friend
      friend.save
    end
    
  end
  
end
