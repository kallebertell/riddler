require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase

  test "should redirect to login form if not logged in" do
  	get :new  	
  	assert_redirected_to login_path
  end
end
