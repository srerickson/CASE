require 'spec_helper'

describe Bird do

  before(:each) do
    @bird = build(:bird)
  end

  it "is valid with proper values" do
    @bird.should be_valid
  end

end