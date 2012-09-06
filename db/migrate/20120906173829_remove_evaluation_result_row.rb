class RemoveEvaluationResultRow < ActiveRecord::Migration
  def self.up
    drop_table "evaluation_results"
  end

  def self.down
    create_table "evaluation_results", :force => true do |t|
      t.integer :bird_id, :null => false
      t.integer :evaluation_question_id, :null => false
      t.integer :yes_count, :default => 0
      t.integer :no_count, :default => 0
      t.integer :na_count, :default => 0
      t.text    :yes_comments
      t.text    :no_comments
      t.text    :na_comments
      t.integer :blank_count, :default => 0
    end
  end
end
