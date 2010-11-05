class Question < ActiveRecord::Base
  belongs_to :game
  has_many :choices, :dependent => :destroy
  belongs_to :correct_choice, :class_name => 'Choice'

  def answered_correctly?
    correct_choice && correct_choice.answered?
  end
end
