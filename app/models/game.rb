class Game < ActiveRecord::Base
  has_many :questions
  belongs_to :user
  
  def rounds_left?
    wrong_answers < max_wrong_answers
  end

  def points
    questions.reduce(0) do |sum, question|
      if question.answered_correctly?
        sum + 1
      else
        sum
      end
    end
  end

end
