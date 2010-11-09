class ModifyQuestionTextColumnType < ActiveRecord::Migration
  def self.up
    remove_column :questions, :text
    add_column :questions, :text, :text
  end

  def self.down
    remove_column :questions, :text
    add_column :questions, :text, :string
  end
end
