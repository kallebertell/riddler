class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :game_id
      t.string :message
      t.string :fb_status_id
      t.string :fb_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
