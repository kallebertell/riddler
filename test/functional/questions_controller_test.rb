require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
  end

  test 'should find own question' do
    game = Factory(:game, :user_id => @user.id)
    question = game.questions.first

    login_as(@user) do
      get :show, :id => question.id, :game_id => game.id
      assert_response :success
      assert_not_nil assigns(:question)
    end
  end

  test 'should not find not own question' do
    game = Factory(:game)
    question = game.questions.first

    login_as(@user) do
      assert_raise ActiveRecord::RecordNotFound do
        get :show, :id => question.id, :game_id => game.id
      end
      assert_nil assigns(:question)
    end
  end
  
end
