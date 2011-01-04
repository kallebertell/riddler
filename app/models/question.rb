class Question < ActiveRecord::Base
  include QuestionFactory
  belongs_to :game
  has_many :choices, :dependent => :destroy

  before_validation :set_random_question_attributes, :on => :create

  enum_attr :question_type, %w(status birthdate like)

  def text
    case question_type
    when :status
      "Who said this?"
    when :birthdate
      "When is this person's birthday?"
    when :like
      "Who #{concept_of_matter_in_question_form}?"
    end
  end

  def concept_of_matter_in_question_form
    case concept_of_matter.to_sym
    when :tv
      'likes to watch this on tv'
    when :interest
      "is interested in..."
    else
      "likes this #{concept_of_matter}"
    end
  end

  def answered_correctly?
    return (1 == self.choices.where( :correct => true, :selected => true ).count) &&
      (1 == self.choices.where( :correct => true).count) &&
      (1 == self.choices.where( :selected => true).count)
  end

  def answer!(choice_id)
    throw :already_answered unless choices.where(:selected => true).empty?
    choices.find(choice_id).update_attribute(:selected, true)
    
    if !game.rounds_left?
      user = game.user
    
      if user.alltime_score.nil? 
        user.alltime_score = 0
      end

      user.alltime_score += @game.points;
    
      if user.best_score.nil? 
        user.best_score = 0
      end
      
      if user.best_score < @game.points
        user.best_score = @game.points
      end
      
      user.save
    end
  end
  
  def correct_choice
    choices.each do |choice|
      return choice if choice.correct?    
    end
  end
  
end
