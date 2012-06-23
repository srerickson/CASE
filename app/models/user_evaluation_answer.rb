class UserEvaluationAnswer < ActiveRecord::Base

  belongs_to :evaluation_question
  belongs_to :user_evaluation

  def yes?
    self.answer == "YES"
  end

  def no?
    self.answer == "NO"
  end

  def n_a?
    self.answer == "N/A"
  end
  
end
