require 'test_helper'

class GameAnsweringProcessTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "game answering and getting results" do
    log_in do |user|
      user.should_get_index
      user.should_get_redirected_to_first_question_when_game_is_created
    end
  end

  private

  def log_in
    login_as(Factory(:user)) do
      user = open_session do |sess|
        sess.extend(GameAnsweringDSL)
      end
      yield user
    end
  end

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
    
    def should_answer_question

    end 
    
    
  end

end
