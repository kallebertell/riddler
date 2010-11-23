class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :game_id
      t.string :name
      t.string :fb_user_id
      t.string :pic_square_url
      t.string :birthday_date

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
