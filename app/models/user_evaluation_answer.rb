class UserEvaluationAnswer < ActiveRecord::Base

  has_paper_trail


  belongs_to :evaluation_question
  belongs_to :user_evaluation
  
  has_one :evaluation_set, :through => :evaluation_question
  has_one :bird, :through => :user_evaluation

  after_save :update_results
  after_destroy :update_results
  
  scope :for_question, lambda { |i| where("evaluation_question_id in (?)", i) }
  scope :for_bird, lambda { |i| includes(:user_evaluation).where("user_evaluations.bird_id in (?)", i) }
  scope :for_user_evaluation, lambda { |i| where("user_evaluation_id in (?)", i)  }
  scope :for_evaluation_set, lambda { |i| includes(:evaluation_set).where("evaluation_sets.id in (?)", i) }
  scope :for_answer, lambda{ |a| where("answer = ?", a) }

  scope :with_comment, where("user_evaluation_answers.comment != '' and user_evaluation_answers.comment is not NULL")

  scope :incomplete_answers, where("user_evaluation_answers.answer = '' or user_evaluation_answers.answer is NULL")
  scope :complete_answers, where("user_evaluation_answers.answer != '' and user_evaluation_answers.answer is not NULL")

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
  
  
  # Every time an answer to a question is created or saved,
  # update the appropriate bird/question record in the 
  # evaluation_results table 
  
  def update_results
    EvaluationResult.rebuild(evaluation_question.id)
  end
  
end
