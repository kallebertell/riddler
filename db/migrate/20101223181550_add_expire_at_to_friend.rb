class AddExpireAtToFriend < ActiveRecord::Migration
  def self.up
    add_column :friends, :expire_at, :timestamp
  end

  def self.down
    remove_column :friends, :expire_at
  end
end