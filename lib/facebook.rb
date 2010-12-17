module Facebook
  include Koala


  class Error < RuntimeError
  end

  class Session

    def initialize(fb_id, fb_secret, callback_url)
      @oauth = Koala::Facebook::OAuth.new(fb_id, fb_secret, callback_url)
    end

    def url_for_oauth_code
      @oauth.url_for_oauth_code(:permissions => ["offline_access","friends_status","friends_birthday","friends_likes"])
    end

    def connect(code)    
      @graph = Koala::Facebook::GraphAPI.new(@oauth.get_access_token(code))
      @api = Koala::Facebook::RestAPI.new(@oauth.get_access_token(code))

    rescue Koala::Facebook::APIError
      raise Error
    end

    def get_current_user
      return @user ||= @graph.get_object('me')
    end

    def fetch_game_data
      friend_uid_query = "SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s}"#TODO consider LIMIT 0,50"

      status_query = 'SELECT uid, status_id, message '+
                     'FROM   status '+
                     'WHERE  uid IN (SELECT uid2 from #friend_uids)'

      friend_query = 'SELECT uid, name, pic_square, birthday_date, music, tv, movies, books, activities, interests '+
                     'FROM   user '+
                     'WHERE  uid IN (SELECT uid2 from #friend_uids)'

      data = @api.rest_call("fql.multiquery", "queries" => { "friend_uids" => friend_uid_query,
                                                             "friends" => friend_query,
                                                             "statuses" => status_query} )

      return {"friends"  => data[1]['fql_result_set'], "statuses" => data[2]['fql_result_set']}
    end

    def get_friends_statuses
      fql("SELECT uid, status_id, message FROM status " +
          "WHERE uid IN " +
          "(SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s})")
    end


    def get_friends
      fql("SELECT uid, name, pic_square, birthday_date FROM user " +
          "WHERE uid IN "+
          "(SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s})")
    end

    private 

    def fql(query)
      @api.fql_query(query)
    end 

  end

end
