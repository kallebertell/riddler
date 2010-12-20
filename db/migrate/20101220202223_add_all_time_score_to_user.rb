class AddAllTimeScoreToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :alltime_score,  :integer
  end

  def self.down
    remove_column :users, :alltime_scores 
  end
end
