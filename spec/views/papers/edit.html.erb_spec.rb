require 'spec_helper'

describe "papers/edit.html.erb" do
  before(:each) do
    @paper = assign(:paper, stub_model(Paper,
      :title => "MyString",
      :pubmed_id => 1,
      :journal => "MyString",
      :abstract => "MyString",
      :summary => "MyString"
    ))
  end

  it "renders the edit paper form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => papers_path(@paper), :method => "post" do
      assert_select "input#paper_title", :name => "paper[title]"
      assert_select "input#paper_pubmed_id", :name => "paper[pubmed_id]"
      assert_select "input#paper_journal", :name => "paper[journal]"
      assert_select "input#paper_abstract", :name => "paper[abstract]"
      assert_select "input#paper_summary", :name => "paper[summary]"
    end
  end
end
