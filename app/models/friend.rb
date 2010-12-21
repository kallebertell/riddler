class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :statuses
end
