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

  test "should end game if we answer incorrectly" do
    game = Factory(:game, :wrong_answers => 2)
    user = game.user
    5.times do
      game.questions.create
    end
    question = game.questions.last

    incorrect_choice_id = 0
    question.choices.each { |choice| incorrect_choice_id = choice.id unless choice.id == question.correct_choice.id }

    login_as(user) do 
      assert_difference 'game.points', 0 do
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => incorrect_choice_id
        assert_redirected_to game_path(game)
        assert !assigns(:question).answered_correctly?
      end
    end
  end



  test "should be able to answer to own question correctly and move on to the next" do
    game = Factory(:game, :wrong_answers => 1)
    user = game.user
    game.questions.create()
    question = game.questions.first
    login_as(user) do 
        post :create, :game_id => game.id, :question_id => question.id, :choice_id => question.correct_choice.id
        assert_redirected_to game_question_path(game, assigns(:game).questions.last)
        assert assigns(:question).answered_correctly?
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
