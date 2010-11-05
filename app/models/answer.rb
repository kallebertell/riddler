class Answer < ActiveRecord::Base
  belongs_to :choice
  belongs_to :user
  validates_presence_of :choice_id
  validates_presence_of :user_id
end
