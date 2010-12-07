require 'test_helper'
require 'data/facebook_response'

class GameAnsweringProcessTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "game answering and getting results" do
    user = login_as()
    user.should_get_index
    user.should_get_redirected_to_first_question_when_game_is_created
  end

  private

  module GameAnsweringDSL
    def should_get_redirected_to_first_question_when_game_is_created
      post games_path
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_not_nil assigns(:question)
    end

    def should_get_index
      get root_path
      assert_response :success
    end
  end


  def login_as
    open_session do |sess|
      sess.extend(GameAnsweringDSL)
      user = Factory(:user)
      mocked_session = mock()
      mocked_session.stubs(:get_friends_and_statuses).then.returns(FRIEND_MOCK_DATA)
      
      ApplicationController.send(:define_method, :session) do
        return @session_cache ||= { :user_id => user.facebook_id, :fb_session => mocked_session }
      end
    end
  end

end
