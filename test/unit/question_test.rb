require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "should create question with type" do
    @game = Factory(:new_game)
    status = Factory(:status, :game_id => @game.id)
    status = Factory(:friend, :game_id => @game.id)
    question = @game.questions.create
    assert [Question::STATUS, Question::BIRTHDATE].include?(question.question_type)
  end

end
