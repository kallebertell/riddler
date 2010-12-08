require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  test "should create a new game of ten rounds and the first question" do
    user = Factory(:user)
    login_as(user) do 
      assert_difference('Game.count', 1) do
        assert_difference('Question.count', 1) do
          post :create
          assert_response :redirect
        end
      end
    end
  end

  test 'should not show the results of someone elses game' do
    user = Factory(:user)
    others_game = Factory(:game)
    login_as(user) do 
      assert_raise ActiveRecord::RecordNotFound do
        get :show, :id => others_game.id
      end
    end
  end

  test 'should show the results of own game' do
    user = Factory(:user)
    others_game = Factory(:game, :user_id => user.id)
    login_as(user) do 
      get :show, :id => others_game.id
      assert_response :success
      assert_not_nil assigns(:game)
    end
  end
end
