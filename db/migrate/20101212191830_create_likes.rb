class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.boolean :used_in_like_question
      t.string :name
      t.string :like_type
      t.string :fb_user_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :likes
  end
end
