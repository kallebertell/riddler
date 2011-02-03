class User < ActiveRecord::Base
    include ActionView::Helpers::TextHelper
  has_many :games
  has_many :friends
  has_many :statuses
  has_many :likes

  def self.find_user_and_friends(user_id)
    friend_ids = find_friend_ids(user_id)
    #Only in PostgreSQL 8.4+
    #self.select("row_number() OVER () as rank, #{User.table_name}.*").where('facebook_id IN (?)', friend_ids).order("best_score DESC")
    #PostgreSQL 8.3-: http://explainextended.com/2009/05/05/postgresql-row-numbers/
    self.find_by_sql(
      "SELECT rank, (arr[rank]).* 
       FROM  ( SELECT  arr, generate_series(1, array_upper(arr, 1)) AS rank 
               FROM    ( SELECT  ARRAY ( SELECT #{User.table_name} 
                                         FROM  #{User.table_name} 
                                         ORDER BY best_score DESC
                                       ) AS arr
                       ) q2
             ) q3 
       WHERE (arr[rank]).facebook_id IN ('#{friend_ids.join("','")}')")
  end

  def self.find_user_and_friends_ordered_by_week_score(user_id)
    friend_ids = find_friend_ids(user_id)
    friend_users =
      self.find_by_sql(
        "SELECT u.*, 0 as rank, #{this_weeks_best_score}, #{this_weeks_total_score}
         FROM #{User.table_name} u
         WHERE u.facebook_id IN ('#{friend_ids.join("','")}')
         ORDER BY this_weeks_best_score DESC")
       
    rank_cnt = 1
    friend_users.each do |u| 
      u.rank = rank_cnt
      rank_cnt += 1
    end
    
    return friend_users
  end
  
  def self.find_friend_ids(user_id)
    Friend.select('fb_user_id').where('user_id = ?', user_id).map(&:fb_user_id) + [User.find(user_id).facebook_id]
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

    Friend.mass_insert(%w(user_id fb_user_id name pic_square_url birthday_date about), 
             friend_datas.map { |friend_data|
               [self.id,
                friend_data['uid'],
                friend_data['name'],
                friend_data['pic_square'],
                friend_data['birthday_date'],
                  truncate(friend_data['about_me'], :length => 255, :imission => '...')]
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
  
  private
  
  def self.this_weeks_best_score
    "CASE WHEN EXTRACT(WEEK FROM score_recorded_at) = #{current_week} THEN week_best_score ELSE 0 END AS this_weeks_best_score"
  end
  
  def self.this_weeks_total_score
    "CASE WHEN EXTRACT(WEEK FROM score_recorded_at) = #{current_week} THEN week_total_score ELSE 0 END AS this_weeks_total_score"
  end  
  
  def self.current_week
    Date.today.cweek
  end
end
