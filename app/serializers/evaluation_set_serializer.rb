class EvaluationSetSerializer < ActiveModel::Serializer

  attributes :id

  has_many :evaluation_questions
  has_many :evaluation_results
  # has_many :user_evaluations
  # has_many :user_evaluation_answers

end