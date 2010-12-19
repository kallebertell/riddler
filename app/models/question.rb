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
      "In which month is this person born?"
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
  end
  
  def correct_choice
    choices.each do |choice|
      return choice if choice.correct?    
    end
  end
  
end
