FactoryGirl.define do 
  factory :user_evaluation_answer do

    # evaluation_question
    # user_evaluation 

    factory  :user_eval_answer_yes do 
      answer UserEvaluationAnswer.yes
    end

    factory :user_eval_answer_no do 
      answer UserEvaluationAnswer.no
    end

    factory :user_eval_answer_na do 
      answer UserEvaluationAnswer.na
    end
  end
end
