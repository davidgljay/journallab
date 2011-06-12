require 'spec_helper'

describe "authors/new.html.erb" do
  before(:each) do
    assign(:author, stub_model(Author,
      :firstname => "MyString",
      :lastname => "MyString"
    ).as_new_record)
  end

  it "renders new author form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => authors_path, :method => "post" do
      assert_select "input#author_firstname", :name => "author[firstname]"
      assert_select "input#author_lastname", :name => "author[lastname]"
    end
  end
end
