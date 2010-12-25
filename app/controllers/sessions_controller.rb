class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :verify_authenticity_token, :only => 'login'

  def new
  end

  def login
    oauth_params = @fb_session.parse_signed_request(params[:signed_request])
    logger.info(oauth_params.inspect)
    if oauth_params && oauth_params['oauth_token']
      @fb_session.connect_with_oauth_token(oauth_params['oauth_token'])
      set_user_session(@fb_session.get_current_user)
      redirect_to root_url
    else
      render :text => "<script>top.location='#{@fb_session.url_for_canvas_login}'</script>"
    end
  end

  def create
    @fb_session.connect_with_code(params[:code])
    set_user_session(@fb_session.get_current_user)

    flash[:notice] = "Logged in as #{current_user.name} successfully."
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
  private

  def set_user_session(fb_user_attributes)
    session[:user_id] = fb_user_attributes['id']
    user = User.find_by_facebook_id(fb_user_attributes['id'])
    user ||= User.create(:facebook_id => fb_user_attributes['id'])
    user.update_profile_attributes(fb_user_attributes)
  end

end
