# require File.dirname(__FILE__) + '/../../lib/facebook'

class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery

  before_filter :set_session_variables
  before_filter :login_required

  private

  def set_session_variables
    @fb_session = session[:fb_session];

    if (!@fb_session)
    	@fb_session = session[:fb_session] = Facebook::Session.new(FB_APP_ID, FB_SECRET, create_session_url)
    end
  end

end
