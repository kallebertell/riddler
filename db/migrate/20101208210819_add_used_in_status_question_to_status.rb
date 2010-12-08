class AddUsedInStatusQuestionToStatus < ActiveRecord::Migration
 def self.up
    change_table :statuses do |t|
      t.boolean :used_in_status_question, :default => false
    end
  end

  def self.down
     remove_column :statuses, :used_in_status_question
  end
end
