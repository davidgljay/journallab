require 'spec_helper'

describe Paper do
 
  before(:each) do
    @attr = {
             :title => "Sample Paper",
             :pubmed_id => "12345678",
             :journal => "XYZ Journal",
             :abstract => "abstract",
             :summary => "summary"
             }
  end         

  it "should create a new instance given valid attributes" do
    Paper.create!(@attr)
  end

  it "should require a pubmed id" do
    no_pubmed_paper = Paper.new(@attr.merge(:pubmed_id => ""))
    no_pubmed_paper.should_not be_valid
  end

  it "should require the pubmed id to be 8 characters" do
    short_pubmed_paper = Paper.new(@attr.merge(:pubmed_id => "1"))
    short_pubmed_paper.should_not be_valid
  end

  describe "author associations" do
     before(:each) do
        @paper = Paper.create!(@attr)
        @author = Author.create({:firstname => "David", "lastname" => "Jay"})
        @author.authorships.create(@paper)
     end

     it "should exist" do
        @paper.authors.should include(@author)
     end
  end
end
