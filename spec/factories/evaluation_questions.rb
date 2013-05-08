FactoryGirl.define do 
  factory :evaluation_question do
    sequence(:question) {|n|  "Question #{n}" } 
  end
end
