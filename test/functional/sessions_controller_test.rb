require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get login page" do
    get :create
    assert_redirected_to '/'
  end
end
