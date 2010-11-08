class AddTextToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :text, :string
  end

  def self.down
    remove_column :questions, :text
  end
end
