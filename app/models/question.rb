class Question < ActiveRecord::Base
  belongs_to :game
  has_many :choices, :dependent => :destroy
  belongs_to :correct_choice, :class_name => 'Choice'

  # The types of possible questions
  # NOTE: use inheritence instead?
  STATUS = "status"
  BIRTHDATE = "birthdate"

  def answered_correctly?
    correct_choice && correct_choice.answered?
  end
  
  def correct_choice
    choices.each do |choice|
      return choice if choice.correct?    
    end
  end
  
end
