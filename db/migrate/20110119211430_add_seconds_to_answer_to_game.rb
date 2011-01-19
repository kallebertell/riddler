class AddSecondsToAnswerToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :seconds_to_answer, :integer, :default => 10, :null => false
  end

  def self.down
    remove_column :games, :seconds_to_answer
  end
end
