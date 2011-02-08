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
    
    unless (time_matches_this_week?(user.score_recorded_at))
      user.week_total_score = 0
      user.week_best_score = 0
    end
     
    user.week_total_score += points;
    user.total_score += points

    user.week_best_score = points if user.week_best_score < points;
    user.best_score = points if user.best_score < points

    user.score_recorded_at = Date.today

    user.save
  end

  private
  
  def current_week
    Date.today.cweek
  end
  
  def time_matches_this_week?(time)
    !time.nil? && time.to_date.cweek == current_week
  end
  
end
