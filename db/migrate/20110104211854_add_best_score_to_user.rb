class AddBestScoreToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :best_score, :integer
  end

  def self.down
    remove_column :users, :best_score
  end
end
