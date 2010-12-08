require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase

  def self.helper_method(*args)
    #ignore
  end
  include Authentication

  def setup
    @http = mock()
    @request = mock()
  end

  test "current_user should return user based on session and cached result in the future" do
    assert !logged_in?

    user = Factory(:user, :facebook_id => 'user_test_id')
    assert_equal user, current_user
    session[:user_id] = 'fubar'
    assert_equal user, current_user

    assert logged_in?
  end

  test "login_required should do nothing when logged in" do
    user = Factory(:user, :facebook_id => 'user_test_id')
    @http.expects('redirect_to').never
    login_required
  end

  test "login_required should redirect to login_url when logged out" do
    @http.expects('redirect_to')
    @request.stubs('fullpath')
    login_required
  end

  test 'should reirect to return_to address' do
    @http.expects('redirect_to').with('testing')
    redirect_to_target_or_default('def')
  end

  private

  def redirect_to(params)
    @http.redirect_to(params)
  end

  def flash
    { }
  end

  def session
    { :user_id => 'user_test_id', :return_to => 'testing' }
  end

  def request
    @request
  end

  def login_url
    '/login/url'
  end

end
