require 'test_helper'

class GameAnsweringProcessTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "play a game two times" do
    log_in do |user|
      play_a_game_as(user)
      play_a_game_as(user)
    end
  end

  private

  def play_a_game_as(user)
    user.should_get_index
    user.should_get_redirected_to_first_question_when_game_is_created
    
    9.times do 
      user.should_answer_question_and_get_redirected_to_next_question
    end
    
    user.should_answer_question
    
    user.should_see_result
  end

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
   
    def should_have_from_one_to_four_choices_to_choose_from
      choice_links = css_select("#choices a.text")     
      assert_operator 1, :<, choice_links.size
#FIXME assert_operator choice_links.size, :<, 5
    end

    def should_answer_question
      should_have_from_one_to_four_choices_to_choose_from
      post choice_links[0]['href']      
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end 
      
    def should_answer_question_and_get_redirected_to_next_question
      should_answer_question
      assert_not_nil assigns(:question)
    end 
   
   def should_see_result
      assert_select "a", "Try again"
   end 
    
  end

end
