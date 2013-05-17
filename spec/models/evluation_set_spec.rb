require 'spec_helper'

describe EvaluationSet do

  before(:each) do
    @num_qs = 10
    @eval_set = FactoryGirl.build(:evaluation_set_with_questions, q_count: @num_qs)
  end

  it "is valid with proper values" do 
    @eval_set.should be_valid
  end

 
end