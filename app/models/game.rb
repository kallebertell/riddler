class Game < ActiveRecord::Base
  has_many :questions, :order => 'id'
  belongs_to :user
  
  def rounds_left?
    wrong_answers < max_wrong_answers && (questions.empty? or !questions.last.answered_late?)
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
  
  def end
    user.alltime_score += points
    user.best_score = points if user.best_score < points
    user.save
  end

end
