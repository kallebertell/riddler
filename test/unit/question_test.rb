require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "should create one of the enum types as question type" do
    @game = Factory(:new_game)
    status = Factory(:status, :game_id => @game.id)
    status = Factory(:friend, :game_id => @game.id)
    question = @game.questions.create
    assert question.enums(:question_type).include?(question.question_type)
  end

  test "should create a status question with several friends" do
    @game = Factory(:game)
    question = @game.questions.create(:question_type => :status)
    assert question.question_type_status?
    assert_equal 4, question.choices.size
    assert_not_nil Friend.find_by_name(question.choices.first.text)
    assert_not_nil Status.find_by_message(question.matter)
  end

  test "should create a valid like question with several friends" do
    @game = Factory(:game)
    question = @game.questions.create(:question_type => :like)
    assert question.question_type_like?
    assert_equal 4, question.choices.size
    assert_not_equal question.choices.first, question.choices.last
    assert_not_nil Friend.find_by_name(question.choices.first.text)
    assert_not_nil Like.find_by_name(question.matter)
  end

  test "should create a valid birthdate question even with one friend" do
    @game = Factory(:new_game)
    status = Factory(:friend, :game_id => @game.id)
    question = @game.questions.create(:question_type => :birthdate)
    assert question.question_type_birthdate?
    assert_equal 3, question.choices.size
    assert_not_nil Friend.find_by_name(question.matter)
  end

  test "should fail creating bogus question type" do
    @game = Factory(:new_game)
    assert_no_difference 'Question.count' do
      assert_raise EnumeratedAttribute::InvalidEnumeration do
        question = @game.questions.create(:question_type => :bogus)
      end
    end
  end

  test 'should determine correct choice' do
    game = Factory(:game)
    question = game.questions.first
    assert_equal 1, question.choices.select { |c| c.correct }.size
    assert_equal question.choices.detect { |c| c.correct }, question.correct_choice
  end

  test 'should answer correctly' do
    game = Factory(:game)
    question = game.questions.first
    question.answer!(question.correct_choice.id)

    assert question.answered_correctly?
  end
end
