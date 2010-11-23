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
    if (@user) 
    	return @user
    end
    
    return @user = @graph.get_object('me')
  end
  
  def get_friends_statuses
    fql("SELECT uid, status_id, message FROM status " +
        "WHERE uid IN " +
        "(SELECT uid2 FROM friend WHERE uid1 = #{@user['id'].to_s})")
  end
  
  def get_users_details(uids)
    fql("SELECT uid, name, pic_square, birthday_date FROM user " +
        "WHERE uid IN (#{uids.join(', ')})")
  end

  def get_friends_with_birthday
    fql("SELECT uid, name, birthday_date FROM user " +
        "WHERE uid IN "+
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
