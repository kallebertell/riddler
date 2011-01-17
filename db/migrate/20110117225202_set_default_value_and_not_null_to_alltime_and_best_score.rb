class SetDefaultValueAndNotNullToAlltimeAndBestScore < ActiveRecord::Migration
  def self.up
    change_column :users, :alltime_score, :integer, :default => 0, :null => false
    change_column :users, :best_score, :integer, :default => 0, :null => false
  end

  def self.down
    change_column :users, :alltime_score, :integer
    change_column :users, :best_score, :integer
  end
end
