require 'test_helper'

class QuestionFactoryTest < ActiveSupport::TestCase

  def setup
    @game = Factory(:game)
    @question_factory = QuestionFactory.new(@game)
  end

  test "should build question of type status" do
    status_question = @question_factory.create_status_question()
    assert_equal Question::STATUS, status_question.question_type    
  end

end
