FactoryGirl.define do 
  factory :evaluation_set do 


    factory :evaluation_set_with_questions do 
      ignore do
        q_count 5
      end
      after(:build) do |set, evaluator|
        set.evaluation_questions = FactoryGirl.build_list(:evaluation_question, evaluator.q_count)
      end
    end


  end
end
