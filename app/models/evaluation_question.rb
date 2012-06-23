class EvaluationQuestion < ActiveRecord::Base

  belongs_to :evaluation_set
  has_many :user_evaluation_answers

  def to_s
    "#{position}. #{question}"
  end

end
