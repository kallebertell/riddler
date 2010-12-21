class AddUserIdToStatusFriendAndLike < ActiveRecord::Migration
  def self.up
    add_column :friends, :user_id,  :integer
    add_column :statuses, :user_id,  :integer
    add_column :likes, :user_id,  :integer    
  end

  def self.down
    remove_column :likes, :user_id
    remove_column :statuses, :user_id
    remove_column :friends, :user_id
  end
end
