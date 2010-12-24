class User < ActiveRecord::Base
    include ActionView::Helpers::TextHelper
  has_many :games
  has_many :friends
  has_many :statuses
  has_many :likes
  
  def update_facebook_data(fb_session)
    
    @init = Time.now.to_f

    # Fetch current cached fb data so we can optimize the data fetch from facebook
    all_friend_fb_uids = Friend.where(:user_id => id).map { |f| f.fb_user_id }
    expired_friend_fb_uids = Friend.where(:user_id => id).expired_since(Time.now).map { |f| f.fb_user_id }
    latest_status = Status.where(:user_id => id).order("created_at DESC").first

    if (latest_status.nil?)
      latest_status_created_at = Time.now - 10.days 
    else
      latest_status_created_at = latest_status.created_at
    end
    
    if ( (Time.now - 10.days) > latest_status_created_at) 
      latest_status_created_at = Time.now - 10.days
    end
    
    data = fb_session.fetch_game_data(all_friend_fb_uids, expired_friend_fb_uids, latest_status_created_at)

    status_datas = data['statuses']
    friend_datas = data['friends']
    
    Friend.delete_all({:user_id => id, :fb_user_id => expired_friend_fb_uids})

    Friend.mass_insert(%w(user_id fb_user_id name pic_square_url birthday_date expire_at), 
             friend_datas.map { |friend_data|
               [self.id,
                friend_data['uid'],
                friend_data['name'],
                friend_data['pic_square'],
                friend_data['birthday_date'],
                Time.now + (7 + rand(8)).days]
             })

    Status.mass_insert(%w(user_id fb_user_id fb_status_id created_at message),
             status_datas.map { |status_data|
               [self.id,
                status_data['uid'],
                status_data['status_id'],
                Time.at(status_data['time']),
                truncate(status_data['message'], :length => 255, :omission=> '...')] })
    
    like_attributes = []
    friend_datas.each do |friend_data|
      { :interests => friend_data['interests'],
        :books => friend_data['books'],
        :tv => friend_data['tv'],
        :movies => friend_data['movies'],
        :activities => friend_data['activities'],
        :music => friend_data['music']
      }.map do |key, values|
        values.split(',').map(&:strip).reject(&:blank?).each do |name|
          like_attributes << [self.id, key.to_s.singularize, name, friend_data['uid']]
        end unless values.blank?
      end
    end
    
    Like.delete_all(:user_id => id, :fb_user_id => expired_friend_fb_uids)
    Like.mass_insert(%w(user_id like_type name fb_user_id), like_attributes)
  end
  
end
