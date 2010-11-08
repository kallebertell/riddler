class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
  end

  def create
    @fb_session.connect(params[:code])

    user = @fb_session.get_current_user
    
    session[:user_id] = user['id']
    
    unless @user = User.find_by_facebook_id(user['id'])
      @user = User.create(:facebook_id => user['id'])
    end
    
    @user.update_attributes(user)

    flash[:notice] = "Logged in as #{@user.name} successfully."
    redirect_to_target_or_default(root_url)
    
  rescue Facebook::Error
  	flash[:error] = "Invalid login or password"	
    redirect_to_target_or_default(root_url)
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end

end
