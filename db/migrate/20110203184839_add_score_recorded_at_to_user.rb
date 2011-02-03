class AddScoreRecordedAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :score_recorded_at, :timestamp
  end

  def self.down
    remove_column :users, :score_recorded_at
  end
end
