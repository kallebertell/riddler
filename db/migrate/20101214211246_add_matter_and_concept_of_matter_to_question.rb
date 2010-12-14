class AddMatterAndConceptOfMatterToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :matter, :text
    add_column :questions, :concept_of_matter, :string
    Question.update_all(:matter => 'text')
  end

  def self.down
    remove_column :questions, :concept_of_matter
    remove_column :questions, :matter
  end
end
