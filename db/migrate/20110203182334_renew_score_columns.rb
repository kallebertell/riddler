class RenewScoreColumns < ActiveRecord::Migration
  def self.up
     add_column :users, :week_best_score, :integer, :default => 0
     add_column :users, :week_total_score, :integer, :default => 0
     rename_column :users, :alltime_score, :total_score
     
     User.find(:all).each do |u|
        u.week_best_score = 0
        u.week_total_score = 0
        u.save
     end
   end

   def self.down
     rename_column :users, :total_score, :alltime_score
     remove_column :users, :week_total_score
     remove_column :users, :week_best_score
   end
end
