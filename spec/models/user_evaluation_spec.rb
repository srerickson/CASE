require 'spec_helper'

describe UserEvaluation do 

  before(:each) do 
    @user_eval = build(:user_evaluation)
  end

  it "should be valuid with proper values" do 
    @user_eval.should be_valid
  end

end