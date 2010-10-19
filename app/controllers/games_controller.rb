class GamesController < ApplicationController
  def new
    @game = Game.new

    @query = "SELECT uid, status_id, message FROM status WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = #{@current_user.facebook_id.to_s})";

    @friends_status = @restapi.fql_query(@query);

  end

end
