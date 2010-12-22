class AddUsedAtToFbDataTables < ActiveRecord::Migration
  def self.up
    add_column :likes, :used_at, :timestamp
    add_column :statuses, :used_at, :timestamp
    add_column :friends, :used_at, :timestamp
  end

  def self.down
    remove_column :friends, :used_at	
    remove_column :statuses, :used_at	
    remove_column :likes, :used_at	
  end
end
