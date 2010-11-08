module Facebook
  include Koala


class Error < RuntimeError
end
    
class Session
 
  def initialize(fb_id, fb_secret, create_session_url)
    @oauth = Koala::Facebook::OAuth.new(fb_id, fb_secret, URI.escape(create_session_url))
  end
  
  def connect(code)    
    @graph = Koala::Facebook::GraphAPI.new(@oauth.get_access_token(code))
    @api = Koala::Facebook::RestAPI.new(@oauth.get_access_token(code))
    
    rescue Koala::Facebook::APIError
      raise Error
  end
  
  def get_current_user
    if (@user) 
    	return @user
    end
    
    return @user = @graph.get_object('me')
  end
  
  def url_for_oauth_code(stuff)
    @oauth.url_for_oauth_code(stuff)
  end

  def get_friends_statuses
    fql("SELECT uid, status_id, message FROM status " +
        "WHERE uid IN " +
        "(SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s})")
  end
  
  def get_users_details(uids)
    fql("SELECT uid, name, pic_square FROM user " +
        "WHERE uid IN (#{uids.join(', ')})")
  end


  private 
    
  def fql(query)
    @api.fql_query(query)
  end 

end

end
