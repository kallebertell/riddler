class Game < ActiveRecord::Base
  has_many :questions
  has_many :friends
  has_many :statuses
  belongs_to :user

  def rounds_left?
    round_count > questions.count
  end

  def points
    counter = 0
    questions.reduce(0) do |s,question|
      if question.answered_correctly?
        s+1
      else
        s
      end
    end
  end
end
