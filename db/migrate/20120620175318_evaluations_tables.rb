class EvaluationsTables < ActiveRecord::Migration
  def self.up

    create_table "evaluation_sets" do |t|
      t.string      :name
      t.boolean     :locked
      t.integer     :owner_id
      t.text        :instructions
      t.timestamps
    end

    create_table "evaluation_questions" do |t|
      t.integer     :evaluation_set_id, :null => false
      t.integer     :position
      t.text        :question 
      t.timestamps
    end

    create_table "user_evaluations" do |t|
      t.integer     :user_id,           :null => false
      t.integer     :evaluation_set_id, :null => false
      t.integer     :bird_id,           :null => false
      t.boolean     :complete
      t.timestamps
    end

    create_table "user_evaluation_answers" do |t|
      t.integer     :user_evaluation_id, :null => false
      t.integer     :evaluation_question_id, :null => false
      t.text        :answer
      t.text        :comment
      t.timestamps
    end


  end

  def self.down
    drop_table "evaluation_sets"
    drop_table "evaluation_questions"
    drop_table "user_evaluations"
    drop_table "user_evaluation_answers"

  end
end
