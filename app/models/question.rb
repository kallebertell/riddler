class Question < ActiveRecord::Base
  include QuestionFactory
  belongs_to :game
  has_many :choices, :dependent => :destroy

  before_validation :set_random_question_attributes, :on => :create
  enum_attr :question_type, %w(status birthdate like about)
  
  def text
    case question_type
    when :status
      "Who said this?"
    when :birthdate
      "When is this person's birthday?"
    when :like
      "Who #{concept_of_matter_in_question_form}?"
    when :about
      "Whose 'About Me' is this?"
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

  def answered_late?
    self.created_at + self.game.seconds_to_answer.seconds < self.answered_at
  end

  def answer!(choice_id)
    throw :already_answered unless choices.where(:selected => true).empty?
    choices.find(choice_id).update_attribute(:selected, true)
    self.update_attribute(:answered_at, Time.now)

    game.wrong_answers += 1 unless answered_correctly?
    game.save

    if !game.rounds_left?
      user = game.user
      user.alltime_score += @game.points
      user.best_score = @game.points if user.best_score < @game.points

      user.save
    end
  end

  def correct_choice
    choices.each do |choice|
      return choice if choice.correct?
    end
  end

end
