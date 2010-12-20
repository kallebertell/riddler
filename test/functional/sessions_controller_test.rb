require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get login page" do
    get :create
    assert_redirected_to '/'
  end

  test "should destroy session" do
    session[:user_id] = 'foo'
    get :destroy
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end

  test "should log existing user in" do
    session[:fb_session] = fb_session = mock()
    fb_session.expects(:connect_with_code).with('testcode')
    fb_session.stubs(:get_current_user).then.returns({ 'id' => 'testid' })
    Factory(:user, :facebook_id => 'testid')
    assert_no_difference('User.count') do
      post :create, :code => 'testcode'
      assert_redirected_to root_path
    end
  end

  test "should create new user when logging in" do
    session[:fb_session] = fb_session = mock()
    fb_session.expects(:connect_with_code).with('testcode')
    fb_session.stubs(:get_current_user).then.returns({ 'id' => 'testid' })
    assert_difference('User.count', 1) do
      post :create, :code => 'testcode'
      assert_redirected_to root_path
    end
  end
end
