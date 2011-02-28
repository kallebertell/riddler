class AddGamesLeftToUser < ActiveRecord::Migration
  def self.up
     add_column :users, :games_left, :integer, :default => 3
     User.find(:all).each do |u|
       u.update_attribute :games_left, 3
     end
  end

   def self.down
     remove_column :users, :games_left
   end
end
