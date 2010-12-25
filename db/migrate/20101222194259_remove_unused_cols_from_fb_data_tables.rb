class RemoveUnusedColsFromFbDataTables < ActiveRecord::Migration
  def self.up
    remove_column :likes, :game_id
    remove_column :statuses, :game_id
    remove_column :friends, :game_id
    remove_column :friends, :used_in_birthday_question
    remove_column :likes, :used_in_like_question
    remove_column :statuses, :used_in_status_question
  end

  def self.down
    add_column :likes, :game_id, :integer
    add_column :statuses, :game_id, :integer
    add_column :friends, :game_id, :integer
    add_column :friends, :used_in_birthday_question, :boolean, :default => false
    add_column :likes, :used_in_like_question, :boolean, :default => false
    add_column :statuses, :used_in_status_question, :boolean, :default => false
  end
end
