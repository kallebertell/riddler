class AddWrongAnswerColumnsToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :max_wrong_answers, :integer, :default => 2
    add_column :games, :wrong_answers, :integer, :default => 0
  end

  def self.down
    remove_column :games, :wrong_answers
    remove_column :games, :max_wrong_answers
  end
end
