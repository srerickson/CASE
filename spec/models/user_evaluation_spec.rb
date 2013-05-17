require 'spec_helper'

describe UserEvaluation do 

  before(:each) do 
    # User.all.each{ |u| u.destroy }
    # Bird.all.each{ |b| b.destroy }
    @num_qs = 10
    @eval_set  = create(:evaluation_set_with_questions, q_count: @num_qs)
    # @user_eval = build(:user_evaluation, evaluation_set: @eval_set)
  end

  it "should be valuid with proper values" do 
    @user_eval = build(:user_evaluation, evaluation_set: @eval_set)
    @user_eval.should be_valid
  end

  it "should update evaluation results (basic test pattern)" do
    num_evals   = 3 
    bird        = create(:bird)
    user_evals = create_list(:user_evaluation, num_evals, evaluation_set: @eval_set, bird: bird)

    # eval 1 - all YES
    user_evals[0].user_evaluation_answers.each do |eval_answer|
      eval_answer.answer = UserEvaluationAnswer.yes
      eval_answer.save!
    end

    # eval 2 - all NO
    user_evals[1].user_evaluation_answers.each do |eval_answer|
      eval_answer.answer = UserEvaluationAnswer.no
      eval_answer.save!
    end

    # eval 3 - all NA
    user_evals[2].user_evaluation_answers.each do |eval_answer|
      eval_answer.answer = UserEvaluationAnswer.na
      eval_answer.save!
    end

    # check EvaluationResults
    EvaluationResult.all.size.should be @num_qs
    EvaluationResult.all.each do |result|
      result.yes_count.should be 1
      result.no_count.should  be 1
      result.na_count.should  be 1
    end

  end
  
end