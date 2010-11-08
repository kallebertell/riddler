class ModifyKeyInChoice < ActiveRecord::Migration
  def self.up
    remove_column :choices, :key
    add_column :choices, :key, :string
  end

  def self.down
    remove_column :choices, :key
    add_column :choices, :key, :integer
  end
end
