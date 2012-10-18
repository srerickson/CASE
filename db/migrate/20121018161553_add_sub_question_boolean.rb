class AddSubQuestionBoolean < ActiveRecord::Migration
  def self.up
    add_column :evaluation_questions, :sub_question, :boolean, :default => false
  end

  def self.down
    remove_column :evaluation_questions, :sub_question
  end
end
