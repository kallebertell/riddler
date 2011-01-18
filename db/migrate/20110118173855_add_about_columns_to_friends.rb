class AddAboutColumnsToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :about, :string
    add_column :friends, :about_used_at, :timestamp
  end

  def self.down
    remove_column :friends, :about_used_at
    remove_column :friends, :about
  end
end
