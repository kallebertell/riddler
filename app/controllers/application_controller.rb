class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery

  before_filter :set_session_variables
  before_filter :login_required
  before_filter :log_exception_notifier_data

  private

  def set_session_variables
    @fb_session = (session[:fb_session] ||= Facebook::Session.new(FB_APP_ID, FB_SECRET, URI.escape(create_session_url)))
  end

  def log_exception_notifier_data
    request.env["exception_notifier.exception_data"] = {
      :user_id => session[:user_id]
    }
  end

end
