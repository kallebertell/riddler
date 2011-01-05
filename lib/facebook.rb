module Facebook
  include Koala


  class Error < RuntimeError
  end

  class Session

    def initialize(callback_url)
      @callback_url = callback_url
      @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET, callback_url)
      @permissions = ["friends_status","friends_birthday"]
    end

    def url_for_canvas_login
      url_for_oauth(true)
    end

    def url_for_oauth_code
      url_for_oauth(false)
    end

    def url_for_oauth(is_canvas)
      redirect_uri = is_canvas ? FB_APP_ROOT : @callback_url
      canvas = is_canvas ? '1' : '0'
      fbconnect = is_canvas ? '0' : '1'

      return "https://graph.facebook.com/oauth/authorize?client_id=#{FB_APP_ID}&redirect_uri=#{redirect_uri}&scope=#{@permissions.join(',')}&canvas=#{canvas}&fbconnect=#{fbconnect}"
    end

    def parse_signed_request(signed_request)
      unless signed_request.nil?
        @oauth.parse_signed_request(signed_request)
      end
    end

    def connect_with_code(code)
      connect_with_oauth_token(@oauth.get_access_token(code))
    rescue Koala::Facebook::APIError => e
      raise Error
    end

    def connect_with_oauth_token(oauth_token)
      @graph = Koala::Facebook::GraphAPI.new(oauth_token)
      @api = Koala::Facebook::RestAPI.new(oauth_token)
    end

    def get_current_user
      return @user ||= @graph.get_object('me')
    end

    def fetch_game_data(opts = {})
      statuses_since = opts[:statuses_since] || nil
      
      friend_uid_query = "SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s}"
      
      status_query = "SELECT uid, status_id, message, time "+
                     "FROM   status "+
                     "WHERE  uid IN (SELECT uid2 from #friend_uids) AND time > #{statuses_since.to_i}"

      friend_query = "SELECT uid, name, pic_square, birthday_date, music, tv, movies, books, activities, interests "+
                     "FROM   user "+
                     "WHERE  uid IN (SELECT uid2 from #friend_uids) "
                     
      data = @api.rest_call("fql.multiquery", "queries" => { "friend_uids" => friend_uid_query,
                                                             "friends" => friend_query,
                                                             "statuses" => status_query} )

      return {"friends"  => data[1]['fql_result_set'], "statuses" => data[2]['fql_result_set']}
    end

  end

end
