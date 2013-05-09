class ChangeEvalQuestionPositionToFloat < ActiveRecord::Migration
  def self.up
    change_column :evaluation_questions, :position, :float
  end

  def self.down
    change_column :evaluation_questions, :position, :integer
  end
end
