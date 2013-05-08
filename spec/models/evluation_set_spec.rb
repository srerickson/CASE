require 'spec_helper'

describe EvaluationSet do

  before(:each) do
    @eval_set = build(:evaluation_set_with_questions, q_count: 5)
  end

  it "is valid with proper values" do 
    @eval_set.should be_valid
  end


end