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
  
    describe "Newcount" do
	before :each do 
		@user = create(:user)
		@follow = @user.follows.create(:name => 'zombies', :search_term => 'zombies')
	end

	it "should return the number of recent papers in the feed if there are fewer than 40" do
		@follow.update_feed
		@follow.newcount.should == @follow.feed.count
	end

	it "should return a higher number from pubmed if there are 40 new papers in the feed" do
		@follow.name = "rna"
		@follow.search_term = "rna"
		@follow.update_feed
		@follow.newcount.should > 1000
	end

	it "should return fewer papers from pubmed if there is a recent visit." do
		@follow.name = "rna"
		@follow.search_term = "rna"
		@visit = @follow.visits.new
		@visit.user = @user
		@visit.created_at = Time.now - 1.week
		@visit.save
		@follow.update_feed
		@follow.newcount.should < 1000
	end

	it "should return fewer papers from pubmed if there is a recent visit." do
		@follow.name = "rna"
		@follow.search_term = "rna"
		@visit = @follow.visits.new
		@visit.user = @user
		@visit.created_at = Time.now - 1.day
		@visit.save
		@follow.update_feed
		@follow.newcount.should < 40
	end
  end
end
