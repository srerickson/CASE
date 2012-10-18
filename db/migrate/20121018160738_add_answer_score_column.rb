class AddAnswerScoreColumn < ActiveRecord::Migration
  def self.up
    add_column :evaluation_results, :answer_score, :float, :default => 0    
  end

  def self.down
    remove_column :evaluation_results, :answer_score
  end
end
