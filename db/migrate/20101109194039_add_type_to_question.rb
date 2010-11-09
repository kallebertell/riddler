class AddTypeToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :type, :string
  end

  def self.down
    remove_column :questions, :type
  end
end
