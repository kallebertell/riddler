class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :choice_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_foreign_key(:answers, :choices)
    add_foreign_key(:answers, :users)
  end

  def self.down
    remove_foreign_key(:answers, :users)
    remove_foreign_key(:answers, :choices)
    drop_table :answers
  end
end
