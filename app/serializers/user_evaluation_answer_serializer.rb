class  UserEvaluationAnswerSerializer < ActiveModel::Serializer

  attributes :answer, :comment, :bird_id, :evaluation_question_id

  def bird_id
    object.bird.id
  end

end