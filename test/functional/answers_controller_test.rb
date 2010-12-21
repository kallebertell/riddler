require 'test_helper'

class AnswersControllerTest < ActionController::TestCase

  test "should not be able to answer to someone elses question" do
    game = Factory(:game)
    game_user = Factory(:user)
    other_user = Factory(:user)
    
    game.user = game_user
    game.save
    
    game.questions.create()
    question = game.questions.first
    login_as(other_user) do 
      assert_raise ActiveRecord::RecordNotFound do
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.choices.first.id
      end
    end
  end

  test "should be able to answer to own last question correctly" do
    game = Factory(:game)
    user = game.user
    5.times do
      game.questions.create
    end
    question = game.questions.first
    login_as(user) do 
      assert_difference 'game.points', 1 do
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.correct_choice.id
        assert_redirected_to game_path(game)
        assert assigns(:question).answered_correctly?
      end
    end
  end

  test "should be able to answer to own next question correctly and move on to the next" do
    game = Factory(:game, :round_count => 6)
    user = game.user
    game.questions.create()
    question = game.questions.first
    login_as(user) do 
 #     assert_difference 'game.points', 1 do
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.correct_choice.id
        assert_redirected_to game_question_path(game, assigns(:game).questions.last)
        assert assigns(:question).answered_correctly?
  #    end
    end
  end

  test "should be able to answer wrong to a question" do
    game = Factory(:game)
    user = game.user
    game.questions.create()
    question = game.questions.first
    login_as(user) do 
      correct_id = question.correct_choice.id
      wrong_id = question.choice_ids.detect { |cid| cid != correct_id}
      post :create, :game_id => game.id, :question_id => question.id, :choice_id => wrong_id
      assert_response :redirect
      assert !assigns(:question).answered_correctly?
    end
  end
end
