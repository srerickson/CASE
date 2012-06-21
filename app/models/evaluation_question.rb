class EvaluationQuestion < ActiveRecord::Base

  belongs_to :evaluation_set
  has_many :user_evaluation_answers

end
