require 'spec_helper'

describe Paper do
 
  before(:each) do
    @attr = {:pubmed_id => "12345678"}
  end         

  it "should create a  new instance given valid attributes" do
    Paper.create!(@attr)
  end

  it "should require a pubmed id" do
    no_pubmed_paper = Paper.new(@attr.merge(:pubmed_id => ""))
    no_pubmed_paper.should_not be_valid
  end

  it "should require the pubmed id to be 8 characters" do
    short_pubmed_paper = Paper.new(@attr.merge(:pubmed_id => "1234567"))
    short_pubmed_paper2 = Paper.new(@attr.merge(:pubmed_id => "123456789"))
    short_pubmed_paper.should_not be_valid
    short_pubmed_paper2.should_not be_valid
  end

  describe "author associations" do
     before(:each) do
        @paper = Paper.create!(@attr)
        @author = Author.create({:firstname => "David", "lastname" => "Jay"})
        @paper.authorships.create(:author_id => @author.id)
     end

     it "should exist" do
        @paper.authors.all.should include(@author)
     end
  end

 describe "data population" do
     before(:each) do
          @attr = {:pubmed_id => "18276894"}
          @paper = Paper.create!(@attr)
          @paper.lookup_info
     end

     it "should bring in data from pubmed" do
         @paper.title.should == "The critical importance of retrieval for learning."
     end

     it "should derive authors" do
         @paper.authors.first.lastname.should == "Karpicke"
     end
  end

 describe "assertions" do
     it "should find the latest assertion" do
        @paper = Factory(:paper)
        asrt1 = @paper.assertions.create!(:text => "I love Nanctucket!")
        asrt1.created_at = 5.days.ago 
        @paper.assertions.create!(:text => "I love St. Louis!")
        @paper.assertions.reverse
        @paper.latest_assertion.text.should == "I love St. Louis!"
     end
 end
end
