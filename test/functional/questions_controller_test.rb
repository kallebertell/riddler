require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase

  def setup
    @game = Factory(:game)
    @user = @game.user
    @game.questions.create
  end

  test 'should find own question' do
    question = @game.questions.first

    login_as(@user) do
      get :show, :id => question.id, :game_id => @game.id
      assert_response :success
      assert_not_nil assigns(:question)
    end
  end

  test 'should not find others question' do
    question = @game.questions.first

    other_user = Factory(:user, :facebook_id => "123456")
    
    login_as(other_user) do
      assert_raise ActiveRecord::RecordNotFound do
        get :show, :id => question.id, :game_id => @game.id
      end
      assert_nil assigns(:question)
    end
  end
  
end
