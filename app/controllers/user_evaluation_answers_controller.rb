class UserEvaluationAnswersController < ApplicationController

  respond_to :json

  def index
    eval_set_id = params[:evaluation_set_id]
    question_id = params[:question_id]
    bird_id = params[:bird_id]

    respond_with UserEvaluationAnswer.for_evaluation_set(eval_set_id)
                                     .for_question(question_id)
                                     .for_bird(bird_id)
  end




end