class AddDetailsToChoice < ActiveRecord::Migration
  def self.up
    add_column :choices, :correct?, :boolean
    add_column :choices, :pic_url, :string
    add_column :choices, :text, :string
    add_column :choices, :key, :integer
  end

  def self.down
    remove_column :choices, :key
    remove_column :choices, :text
    remove_column :choices, :pic_url
    remove_column :choices, :correct?
  end
end
