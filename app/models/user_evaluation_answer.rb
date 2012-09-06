class UserEvaluationAnswer < ActiveRecord::Base

  belongs_to :evaluation_question
  belongs_to :user_evaluation
  
  has_one :evaluation_set, :through => :evaluation_question
  has_one :bird, :through => :user_evaluation

  after_save :update_results
  #after_destroy :update_results
  
  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| includes(:user_evaluation).where("user_evaluations.bird_id in (?)", i) }
  scope :for_user_evaluation, lambda { |i| where("user_evaluation_id in (?)", i)  }
  scope :for_evaluation_set, lambda { |i| includes(:evaluation_set).where("evaluation_sets.id in (?)", i) }
  scope :for_answer, lambda{ |a| where("answer = ?", a) }

  scope :incomplete_answers, where("answer = '' or answer is NULL")
  scope :complete_answers, where("answer != '' and answer is not NULL")

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
  
  #
  # Every time an answer to a question is created or saved,
  # update the appropriate bird/question record in the 
  # evaluation_results table 
  #
  # def update_results
  #   b_id = self.user_evaluation.bird_id
    
  #   yes_count = UserEvaluationAnswer.for_bird(b_id)
  #                 .for_question(self.evaluation_question_id)
  #                 .for_answer(UserEvaluationAnswer.yes).count
  #   no_count = UserEvaluationAnswer.for_bird(b_id)
  #                 .for_question(self.evaluation_question_id)
  #                 .for_answer(UserEvaluationAnswer.no).count
  #   na_count = UserEvaluationAnswer.for_bird(b_id)
  #                 .for_question(self.evaluation_question_id)
  #                 .for_answer(UserEvaluationAnswer.na).count

  #   result = EvaluationResult.lookup(b_id,self.evaluation_question_id)              
  #   if result.nil?
  #     result = EvaluationResult.new({
  #       :bird_id => b_id, 
  #       :evaluation_question_id => self.evaluation_question_id 
  #     })
  #   end
  #   result.update_attributes({:yes_count => yes_count, :no_count => no_count, :na_count => na_count})
  #   result.save!  
  # end
  
end
