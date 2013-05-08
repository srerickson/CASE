
FactoryGirl.define do 
  factory :bird do 
    sequence(:name) { |n| "Bird #{n}" }
  end
end