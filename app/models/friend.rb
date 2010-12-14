class Friend < ActiveRecord::Base
  belongs_to :game
  has_many :likes
  has_many :statuses
end
