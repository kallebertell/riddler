class User < ActiveRecord::Base
  attr_accessor :work, :education, :gender, :hometown;
  has_many :games
end
