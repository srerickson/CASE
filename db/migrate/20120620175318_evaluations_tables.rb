class EvaluationsTables < ActiveRecord::Migration
  def self.up

    create_table "evaluation_sets", :force => true do |t|
      t.string      :name
      t.boolean     :locked
      t.integer     :owner_id
      t.text        :instructions
      t.timestamps
    end

    create_table "evaluation_questions", :force => true do |t|
      t.integer     :evaluation_set_id, :null => false
      t.integer     :position
      t.text        :question 
      t.timestamps
    end

    create_table "user_evaluations", :force => true do |t|
      t.integer     :user_id,           :null => false
      t.integer     :evaluation_set_id, :null => false
      t.integer     :bird_id,           :null => false
      t.boolean     :complete
      t.timestamps
    end

    create_table "user_evaluation_answers", :force => true do |t|
      t.integer     :user_evaluation_id, :null => false
      t.integer     :evaluation_question_id, :null => false
      t.text        :answer
      t.text        :comment
      t.timestamps
    end

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

  def self.down
    drop_table "evaluation_sets"
    drop_table "evaluation_questions"
    drop_table "user_evaluations"
    drop_table "user_evaluation_answers"
    drop_table "evaluation_results"
  end

end
