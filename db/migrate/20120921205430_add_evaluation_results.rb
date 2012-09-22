class AddEvaluationResults < ActiveRecord::Migration
  def self.up
    create_table "evaluation_results", :force => true do |t|
      t.integer :bird_id, :null => false
      t.integer :evaluation_question_id, :null => false
      t.integer :yes_count, :default => 0
      t.integer :no_count, :default => 0
      t.integer :na_count, :default => 0
      t.integer :blank_count, :default => 0
      t.integer :yes_comments, :default => 0
      t.integer :no_comments, :default => 0
      t.integer :na_comments, :default => 0
    end
  end

  def self.down
    drop_table "evaluation_results"
  end
end
