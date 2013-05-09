FactoryGirl.define do 
  factory :evaluation_question do
    # evaluation_set
    sequence(:question) {|n|  "Question #{n}" } 
  end
end
