class Game < ActiveRecord::Base
  has_many :questions
  belongs_to :user


  def seconds_to_answer
    return (30-6*Math.log([1,self.questions.count].max).round)
  end
  
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

end
