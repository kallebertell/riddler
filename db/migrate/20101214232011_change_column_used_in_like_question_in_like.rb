class ChangeColumnUsedInLikeQuestionInLike < ActiveRecord::Migration
  def self.up
    change_column :likes, :used_in_like_question, :boolean, :default => false
  end

  def self.down
    change_column :likes, :used_in_like_question, :boolean
  end
end
