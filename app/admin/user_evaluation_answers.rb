ActiveAdmin.register UserEvaluationAnswer do

  menu false
  


  #
  # Controller
  #

  controller do 
    before_filter :get_evaluation_set

    def summary
      @bird =  params[:bird_id].nil? ? nil 
        : Bird.find(params[:bird_id])
      @question = params[:evaluation_question_id].nil? ? nil 
        : EvaluationQuestion.find(params[:evaluation_question_id])
      @answers = UserEvaluationAnswer
        .for_bird(@bird.id)
        .for_question(@question.id)
      @users = @answers.map{|a| a.user_evaluation.user }.uniq!
      render :partial => "summary"
    end

    protected
    def get_evaluation_set
      @evaluation_set = params[:evaluation_set_id].nil? ? nil
        : EvaluationSet.find(params[:evaluation_set_id])
    end
  end


end
