class UserEvaluationAnswer < ActiveRecord::Base

  belongs_to :evaluation_question
  belongs_to :user_evaluation
  
  after_save :update_results
  after_destroy :update_results
  
  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| includes(:user_evaluation).where("user_evaluations.bird_id in (?)", i) }
  scope :for_answer, lambda{ |a| where("answer = ?", a) }

  def yes?  
    self.answer == UserEvaluationAnswer.yes 
  end
  def no?
    self.answer == UserEvaluationAnswer.no 
  end 
  def n_a?  
    self.answer == UserEvaluationAnswer.na  
  end

  # Class Methods
  def self.yes
    "YES"
  end
  def self.no
    "NO"
  end
  def self.na
    "N/A"
  end
  def self.answer_choices
    [self.yes,self.no,self.na]
  end
  
  
  private
  
  # update the evaluation_results table with current   
  def update_results
    b_id = self.user_evaluation.bird_id
    
    yes_count = UserEvaluationAnswer.for_bird(b_id)
                  .for_question(self.evaluation_question_id)
                  .for_answer(UserEvaluationAnswer.yes).count
    no_count = UserEvaluationAnswer.for_bird(b_id)
                  .for_question(self.evaluation_question_id)
                  .for_answer(UserEvaluationAnswer.no).count
    na_count = UserEvaluationAnswer.for_bird(b_id)
                  .for_question(self.evaluation_question_id)
                  .for_answer(UserEvaluationAnswer.na).count

    result = EvaluationResult.lookup(b_id,self.evaluation_question_id)              
    if result.nil?
      result = EvaluationResult.new({
        :bird_id => b_id, 
        :evaluation_question_id => self.evaluation_question_id 
      })
    end
    result.update_attributes({:yes_count => yes_count, :no_count => no_count, :na_count => na_count})
    result.save!  
  end
  
  
  def clear_and_update_results
    self.answer = nil
    self.save!
    update_results
  end
  
end
