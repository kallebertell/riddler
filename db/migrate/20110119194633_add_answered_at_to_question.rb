class AddAnsweredAtToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :answered_at, :datetime
  end

  def self.down
    remove_column :questions, :answered_at
  end
end
