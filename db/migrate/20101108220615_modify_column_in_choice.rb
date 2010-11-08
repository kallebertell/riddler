class ModifyColumnInChoice < ActiveRecord::Migration
  def self.up
    remove_column :choices, :correct?
    add_column :choices, :correct, :boolean
  end

  def self.down
    remove_column :choices, :correct, :boolean
    add_column :choices, :correct?
  end
end
