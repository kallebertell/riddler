class SessionsController < ApplicationController

  def create
    @graph = session[:graph] = Koala::Facebook::GraphAPI.new(@oauth.get_access_token(params[:code]))
    user = @graph.get_object('me')
    p user
    session[:user_id] = user['id']
    unless @user = User.find_by_facebook_id(user['id'])
      @user = User.create(:facebook_id => user['id'])
    end
    flash[:notice] = "Logged in as #{@user.name} successfully."
    redirect_to_target_or_default(root_url)
  rescue Koala::Facebook::APIError
    flash[:error] = "Invalid login or password."
    redirect_to_target_or_default(root_url)
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
