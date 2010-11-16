class DropAnswers < ActiveRecord::Migration
  def self.up
    remove_foreign_key(:answers, :users)
    remove_foreign_key(:answers, :choices)
    drop_table :answers
  end

  def self.down
    create_table :answers do |t|
      t.integer :choice_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_foreign_key(:answers, :choices)
    add_foreign_key(:answers, :users)
  end
end
