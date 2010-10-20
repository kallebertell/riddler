class GamesController < ApplicationController

  def new
    @game = Game.new

    query = "SELECT uid, status_id, message FROM status WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = #{@current_user.facebook_id.to_s})";

    friends_statuses = @restapi.fql_query(query).sort_by {rand};

    status_to_guess = friends_statuses.at(0)
    @correct_uid = status_to_guess['uid'];
    unrelated_uids = get_two_unrelated_uids(friends_statuses, @correct_uid)
    @uids = unrelated_uids.concat([@correct_uid])
    @status_message = status_to_guess['message']

    @friends = @restapi.fql_query("SELECT name FROM user WHERE uid IN (#{@uids.join(', ')})").collect {|x| x['name'] }
  end

  
  private

  def get_two_unrelated_uids(statuses, correct_uid)
    unrelated_uids = []
    cnt = 1;

    while unrelated_uids.size < 2
      uid = statuses.at(cnt)['uid']
      unrelated_uids.push(uid) #if (uid != correct_uid)
      cnt += 1;
      break if (cnt > 999)
    end

    unrelated_uids
  end

end
