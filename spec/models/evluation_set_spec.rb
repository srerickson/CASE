require 'spec_helper'

describe EvaluationSet do

  before(:each) do
    @eval_set = FactoryGirl.build(:evaluation_set_with_questions, q_count: 10)
  end

  it "is valid with proper values" do 
    @eval_set.should be_valid
  end


  it "should work with basic test pattern" do 

    @eval_set.visible_results = true
    @eval_set.save!

    answer_options = [UserEvaluationAnswer.yes, UserEvaluationAnswer.no, UserEvaluationAnswer.na]
    num_users = 3

    possible_pies = answer_options.repeated_combination(num_users).to_a

    users = FactoryGirl.create_list(:user, num_users)
    birds = FactoryGirl.create_list(:bird, possible_pies.size)

    possible_pies.each_with_index do |pie, pie_idx|
      users.each_with_index do |user, user_idx|
        user_eval = FactoryGirl.create(
          :user_evaluation, 
          user: user,
          bird: birds[pie_idx], 
          evaluation_set: @eval_set
        )
        user_eval_answer = user_eval.user_evaluation_answers[0]
        user_eval_answer.answer = pie[user_idx]
        user_eval.save!
      end
    end

    #should be????

  end
 
end