class Like < ActiveRecord::Base
  belongs_to :friend
  belongs_to :game
  enum_attr :like_type, %w(interest book tv movie activity music)
  validates_presence_of :like_type
end
