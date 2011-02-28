class Game < ActiveRecord::Base
  has_many :questions, :order => 'id'
  belongs_to :user
  
  def rounds_left?
    wrong_answers < max_wrong_answers && (questions.empty? or !questions.last.answered_late?)
  end

  def points
    Choice.where(:correct => true, :selected => true, :question_id => self.question_ids).count
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

    user.score_recorded_at = DateTime.now

    user.games_left = user.games_left - 1
    
    user.save
  end

  private
  
  def current_week
    DateTime.now.cweek
  end
  
  def time_matches_this_week?(time)
    !time.nil? && time.to_date.cweek == current_week
  end
  
end
