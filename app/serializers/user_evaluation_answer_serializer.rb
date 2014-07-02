class  UserEvaluationAnswerSerializer < ActiveModel::Serializer

  attributes :answer, :comment, :bird_id, :evaluation_question_id, :user_id

  def bird_id
    object.bird.id
  end

  def user_id
    object.user_evaluation.user_id
  end

end