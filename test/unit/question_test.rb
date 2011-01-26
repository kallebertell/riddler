require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "should answer on time if answered immediately" do
    @game = Factory(:new_game)
    status = Factory(:status, :user_id => @game.user.id)
    status = Factory(:friend, :user_id => @game.user.id)
    question = @game.questions.create
    question.answer!(question.choices.first.id)
    assert !question.answered_late?
  end

  test "should be answered late if answered after 10 seconds" do
    @game = Factory(:new_game)
    status = Factory(:status, :user_id => @game.user.id)
    status = Factory(:friend, :user_id => @game.user.id)
    question = @game.questions.create
    question.update_attribute(:created_at, 31.seconds.ago)
    question.answer!(question.choices.first.id)
    assert question.answered_late?
  end

  test "should create one of the enum types as question type" do
    @game = Factory(:new_game)
    status = Factory(:status, :user_id => @game.user.id)
    status = Factory(:friend, :user_id => @game.user.id)
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
    Factory(:friend, :user_id => @game.user.id)
    question = @game.questions.create(:question_type => :birthdate)
    assert question.question_type_birthdate?
    assert_equal 2, question.choices.size
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
    game.questions.create()
    question = game.questions.first
    assert_equal 1, question.choices.select { |c| c.correct }.size
    assert_equal question.choices.detect { |c| c.correct }, question.correct_choice
  end

  test 'should answer correctly' do
    game = Factory(:game)
    game.questions.create()
    question = game.questions.first
    question.answer!(question.correct_choice.id)

    assert question.answered_correctly?
  end
  
  test 'should set scores when game ends' do
    game = Factory(:game)
    game.user.alltime_score = 0
    
    3.times do
      question = game.questions.create
      # Why isn't this set automatically?
      question.game = game
      question.answer!(question.correct_choice.id)
    end
    
    2.times do
      question = game.questions.create
      question.game = game
    
      incorrect_choice_id = 0
      question.choices.each { |choice| incorrect_choice_id = choice.id unless choice == question.correct_choice }
    
      question.answer!(incorrect_choice_id)
    end
    
    assert_equal 3, game.points
    assert_equal 3, game.user.best_score
    assert_equal 3, game.user.alltime_score
  end
  
end
