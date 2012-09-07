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

      @yes_answers = @answers.select{|a| a.answer == UserEvaluationAnswer.yes} 
      @no_answers  = @answers.select{|a| a.answer == UserEvaluationAnswer.no} 
      @na_answers  = @answers.select{|a| a.answer == UserEvaluationAnswer.na} 

      @yes_comments = @yes_answers.select{|a| !a.comment.blank? }.map{|a| a.comment }
      @no_comments  = @no_answers.select{ |a| !a.comment.blank? }.map{|a| a.comment }
      @na_comments  = @na_answers.select{ |a| !a.comment.blank? }.map{|a| a.comment }

      render :partial => "summary"
    end

    protected
    def get_evaluation_set
      @evaluation_set = params[:evaluation_set_id].nil? ? nil
        : EvaluationSet.find(params[:evaluation_set_id])
    end
  end


end
