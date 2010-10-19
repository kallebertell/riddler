class ApplicationController < ActionController::Base
  include Koala
  include Authentication
  protect_from_forgery

  before_filter :set_session_variables
  before_filter :login_required

  private

  def set_session_variables
    @oauth = session[:oauth] = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET, URI.escape(create_session_url))
    @graph = session[:graph]
    @restapi = session[:restapi]
  end

end
