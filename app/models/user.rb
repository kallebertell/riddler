class User < ActiveRecord::Base
  attr_accessor :work, :education, :gender, :hometown;
  has_many :games
  has_many :friends
  has_many :statuses
  has_many :likes
  
end
