class Game < ActiveRecord::Base
  has_many :questions
  has_many :friends
  has_many :statuses
  belongs_to :user

  def rounds_left?
    round_count > questions.count
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
