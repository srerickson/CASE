class EvaluationQuestion < ActiveRecord::Base

  default_scope  :order => "position ASC"
  
  belongs_to :evaluation_set
  has_many :user_evaluation_answers
  has_many :evaluation_results

  def to_s
    "#{position}. #{question}"
  end

end
