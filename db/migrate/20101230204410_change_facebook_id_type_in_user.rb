class ChangeFacebookIdTypeInUser < ActiveRecord::Migration
  def self.up
    change_column(:users, :facebook_id, :string)
  end

  def self.down
    change_column(:users, :facebook_id, :integer)
  end
end
