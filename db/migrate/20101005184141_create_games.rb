class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :user_id
      t.integer :round_count

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
