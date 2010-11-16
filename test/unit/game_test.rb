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

  test 'should calculate points correctly when several choices are selected' do
    @game_of_0_points = Factory(:game)
    @game_of_0_points.questions[0..2].each do |question|
      correct_choice = question.choices.first
      wrong_choice = question.choices.last
      wrong_choice.selected = true
      wrong_choice.save
      correct_choice.correct = true
      correct_choice.selected = true
      assert_not_equal wrong_choice, correct_choice
      correct_choice.save
    end
    assert_equal 0, @game_of_0_points.points
  end

  test 'should calculate points correctly when three correct choices are selected' do
    @game_of_3_points = Factory(:game)
    @game_of_3_points.questions[0..2].each do |question|
      correct_choice = question.choices.first
      correct_choice.correct = true
      correct_choice.selected = true
      correct_choice.save
    end
    assert_equal 3, @game_of_3_points.points
  end
end
