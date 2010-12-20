class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.integer :question_id

      t.timestamps
    end
    add_foreign_key(:choices, :questions)
  end

  def self.down
    remove_foreign_key(:choices, :questions)
    drop_table :choices
  end
end
