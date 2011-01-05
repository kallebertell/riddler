class User < ActiveRecord::Base
    include ActionView::Helpers::TextHelper
  has_many :games
  has_many :friends
  has_many :statuses
  has_many :likes
  
  def self.find_user_friends(user_id)
     self.find_by_sql("SELECT u.id, u.name, u.alltime_score " + 
                      "FROM #{User.table_name} u , #{Friend.table_name} f " + 
                      "WHERE u.facebook_id = f.fb_user_id AND f.user_id = #{user_id} " + 
                      "ORDER BY u.alltime_score DESC")
  end
  
  def update_facebook_data(fb_session)
    
    @init = Time.now.to_f

    latest_status = Status.where(:user_id => id).order("created_at DESC").first
    fetch_statuses_since = latest_status.created_at unless latest_status.nil?
    
    # Don't fetch statuses which are over 10 days old even if the newest one we have is older
    if (!fetch_statuses_since.nil? && fetch_statuses_since < 10.days.ago) 
      fetch_statuses_since = 10.days.ago
    end
    
    data = fb_session.fetch_game_data( {:statuses_since => fetch_statuses_since} )

    status_datas = data['statuses']
    friend_datas = data['friends']
    
    Friend.delete_all({:user_id => id})

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
    
    Like.delete_all(:user_id => id)
    Like.mass_insert(%w(user_id like_type name fb_user_id), like_attributes)
  end

  def update_profile_attributes(attrs)
    self.update_attributes({
      :name => attrs['name'],
      :email => attrs['email'],
      :location => attrs['location'],
      :timezone => attrs['timezone'],
      :first_name => attrs['first_name'],
      :last_name => attrs['last_name'],
      :birthday => attrs['birthday'],
      :link => attrs['link'],
      :locale => attrs['locale'],
      :verified => attrs['verified'],
      :updated_time => attrs['updated_time']
    })
  end
  
end
