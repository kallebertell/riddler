class Question < ActiveRecord::Base
  include QuestionFactory
  belongs_to :game
  has_many :choices, :dependent => :destroy
  belongs_to :correct_choice, :class_name => 'Choice'

  before_validation_on_create :set_random_question_attributes

  # The types of possible questions
  # NOTE: use inheritence instead?
  STATUS = "status"
  BIRTHDATE = "birthdate"

  def answered_correctly?
    return (1 == choices.where( :correct => true, :selected => true ).count) &&
      (1 == choices.where( :correct => true).count) &&
      (1 == choices.where( :selected => true).count)
  end
  
  def correct_choice
    choices.each do |choice|
      return choice if choice.correct?    
    end
  end
  
end
