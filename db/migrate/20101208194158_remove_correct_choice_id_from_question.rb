class RemoveCorrectChoiceIdFromQuestion < ActiveRecord::Migration
  def self.up
    remove_column :questions, :correct_choice_id
  end

  def self.down
    add_column :questions, :correct_choice_id, :integer
  end
end
