class AddSelectedToChoice < ActiveRecord::Migration
  def self.up
    add_column :choices, :selected, :boolean
  end

  def self.down
    remove_column :choices, :selected
  end
end
