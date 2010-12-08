require 'test_helper'

class AnswersControllerTest < ActionController::TestCase

  test "should not be able to answer to someone elses question" do
    user = Factory(:user)
    game = Factory(:game)
    question = game.questions.first
    login_as(user) do 
      assert_raise ActiveRecord::RecordNotFound do
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.choices.first.id
      end
    end
  end

  test "should be able to answer to own last question correctly" do
    user = Factory(:user)
    game = Factory(:game, :user_id => user.id)
    question = game.questions.first
    login_as(user) do 
      post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.correct_choice.id
      assert Question.find(question.id).answered_correctly?
      assert_redirected_to game_path(game)
    end
  end

  test "should be able to answer to own next question correctly and move on to the next" do
    user = Factory(:user)
    game = Factory(:game, :round_count => 6, :user_id => user.id)
    question = game.questions.first
    login_as(user) do 
      post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.correct_choice.id
      assert_redirected_to game_question_path(game, assigns(:game).questions.last)
      assert Question.find(question.id).answered_correctly?
    end
  end

  test "should be able to answer wrong to a question" do
    user = Factory(:user)
    game = Factory(:game, :user_id => user.id)
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
