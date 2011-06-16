require 'spec_helper'

describe "authors/edit.html.erb" do
  before(:each) do
    @author = assign(:author, stub_model(Author,
      :firstname => "MyString",
      :lastname => "MyString",
      :paper_id => 1
    ))
  end

  it "renders the edit author form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => authors_path(@author), :method => "post" do
      assert_select "input#author_firstname", :name => "author[firstname]"
      assert_select "input#author_lastname", :name => "author[lastname]"
      assert_select "input#author_paper_id", :name => "author[paper_id]"
    end
  end
end
