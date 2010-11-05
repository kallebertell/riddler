class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :game_id
      t.integer :correct_choice_id, :references => :choices

      t.timestamps
    end
    add_foreign_key(:questions, :games)
  end

  def self.down
    remove_foreign_key(:questions, :games)
    drop_table :questions
  end
end
