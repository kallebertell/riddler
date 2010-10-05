class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id
      t.string :name
      t.string :email
      t.string :location
      t.string :timezone
      t.string :first_name
      t.string :last_name
      t.string :birthday
      t.string :link
      t.string :locale
      t.boolean :verified
      t.datetime :updated_time

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
