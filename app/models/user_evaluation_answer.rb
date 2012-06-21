class UserEvaluationAnswer < ActiveRecord::Base

  belongs_to :evaluation_question
  belongs_to :user_evaluation

end
