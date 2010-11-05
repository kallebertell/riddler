require 'test_helper'

class GameTest < ActiveSupport::TestCase
  
  def setup
    @game = Factory(:game)
    @user = Factory(:user)
  end

  test "should read the number of choices correctly" do
    assert_not_nil @game.id
    assert_equal 5*3, @game.questions.map(&:choices).sum.size
  end

  test 'should not have rounds left when all question places are used' do
    assert !@game.rounds_left?
  end

  test 'should have next question coming when not all places are used' do
    @game.questions.last.destroy
    assert @game.rounds_left?
  end

  test 'should calculate points correctly' do
    @game_of_3_points = Factory(:game)
    @game_of_3_points.questions[0..2].each do |question|
      question.correct_choice = question.choices.first
      question.correct_choice.answers.create(:user => @user)
    end
    assert_equal 3, @game_of_3_points.points
  end
end
