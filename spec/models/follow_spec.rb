require 'spec_helper'

describe Follow do
  
  describe "Temp Follows" do
	it "should create temp follows from a string" do
		temp_follows = "test, mrna, judson"
		follows = Follow.new.create_temp(temp_follows)
		follows.count.should == 3
		follows.first.class.should == Follow
	end
  end
end
