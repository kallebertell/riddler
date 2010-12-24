class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :statuses
  
  scope :expired_since, lambda {|time| where("expire_at < ?", time) }
end
