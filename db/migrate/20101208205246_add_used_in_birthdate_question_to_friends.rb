class AddUsedInBirthdateQuestionToFriends < ActiveRecord::Migration
  def self.up
    change_table :friends do |t|
      t.boolean :used_in_birthday_question, :default => false
    end
  end

  def self.down
     remove_column :friends, :used_in_birthday_question
  end
end
