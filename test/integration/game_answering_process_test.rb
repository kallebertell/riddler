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
    
    gameResult = user.css_select(".game_info")
    
    user.should_answer_question_twice_with_same_redirect

    while (gameResult.empty?)
      user.should_answer_question
      gameResult = user.css_select(".game_info")
    end
    
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
   
    def should_select_one_and_have_from_two_to_four_choices
      choice_links = css_select("#choices a.text")     
      assert_operator 1, :<, choice_links.size
#FIXME assert_operator choice_links.size, :<, 5
      return choice_links[0]
    end

    def should_answer_question
      selected_link = should_select_one_and_have_from_two_to_four_choices
      post selected_link['href']      
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end 
      
    def should_answer_question_and_get_redirected_to_next_question
      should_answer_question
      assert_not_nil assigns(:question)
    end 

    def should_answer_question_twice_with_same_redirect
      selected_link = should_select_one_and_have_from_two_to_four_choices
      post selected_link['href']      
      assert_response :redirect
      post selected_link['href']      
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end 
   
   def should_see_result
      assert_select ".create_game", "Try again"
   end 
    
  end

end
