require 'spec_helper'

describe Paper do
 
  before(:each) do
    @attr = {:pubmed_id => "12345678"}
  end         

  it "should create a  new instance given valid attributes" do
    Paper.create!(@attr)
  end

  it "should require the pubmed id to be 12 characters" do
    long_pubmed_paper = Paper.new(@attr.merge(:pubmed_id => "12345678901234567"))
    long_pubmed_paper.should_not be_valid
  end


 describe "data population" do
     before(:each) do
          @attr = {:pubmed_id => "22784682"}
          @paper = Paper.create!(@attr)
          @paper.lookup_info
     end

     it "should bring in data from pubmed" do
         @paper.title.should == "Feeling robots and human zombies: Mind perception and the uncanny valley"
     end

     it "should derive authors" do
         @paper[:authors].first[:lastname].should == "Gray"
     end
  end

 describe "assertions" do
     it "should find the latest assertion" do
        @paper = create(:paper)
        @user = create(:user)
        asrt1 = @paper.assertions.build(:text => "I love Nantucket!")
        asrt1.user = @user
        asrt1.save
        asrt1.created_at = 3.days.ago
        asrt1.save
        asrt2 = @paper.assertions.new(:text => "I love St. Louis!")
        asrt2.user = @user
        asrt2.save
        @paper.assertions.reverse
        @paper.latest_assertion.text.should == "I love St. Louis!"
     end
 end

describe "heatmap_overview" do

	it "should create a heatmap overview" do
		@paper = create(:paper)
		@paper.buildout([3,3,4,2])
		@user = create(:user)
		@paper.comments.build(:text => 'Comment', :form => 'comment', :user => @user)
		@fig = @paper.figs[1]
		@fig.questions.build(:text => 'Question', :user => @user)
		@fig.assertions.build(:text => 'Summary', :user => @user)
		@paper.heatmap
		@overview = @paper.heatmap_overview
	end 

end

describe "build figs" do
	before(:each) do
		@paper = create(:paper)
		@paper.build_figs(4)
		@fig = @paper.figs[0]
	end		

	it "should add figs" do
		@paper.figs.count.should == 4
	end

	it "should remove figs unless there is a comment on them." do
		@fig.comments.build(:text => 'Comment', :form => 'comment', :user => @user)
		@paper.build_figs(1)
		@paper.figs.count.should == 1
	end	

	it "should remove figs unless there is a question on them." do
		@fig.questions.build(:text => 'Question', :user => @user)
		@paper.build_figs(1)
		@paper.figs.count.should == 1
	end	


	it "should remove figs unless there is a summary on them." do
		@fig.assertions.build(:text => 'Summary', :user => @user)
		@paper.build_figs(1)
		@paper.figs.count.should == 1
	end	
end

describe "pubmed search count" do
	it "should see how many papers there are for a given search term on pubmed" do
		Paper.new.pubmed_search_count('zombies').should > 20
	end
	
	it "should see how many people there are for a given search term on pubmed since a particular date" do
		@num = Paper.new.pubmed_search_count('zombies', Time.now - 1.year)
		@num.should > 0
		@num.should < 20
	end
end

describe "pubmed search" do
  it "should return an error if pubmed is not responding" do
    Paper.new.open_html('http://www.8asfkjdsh.net')
    @error.nil?.should be_true
  end

  it "should return a site if one can be opened" do
    @site = Paper.new.open_html('http://www.google.com')
    @site.nil?.should be_false
  end

end

  describe "xml access" do
    it "should return the paper as XML" do
      @paper = create(:paper)
      @paper.buildout([3,2,1,3])
      @user = create(:user)
      @comment = @paper.comments.new(:text => 'Lorem ipsum', :anonymous => 'true', :form => 'comment')
      @comment.user = @user
      @comment.save
      @paper.reload
      @paper.xml_hash[:hascomments].should be_true
    end
  end

end
