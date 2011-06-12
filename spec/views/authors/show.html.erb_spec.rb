require 'spec_helper'

describe "authors/show.html.erb" do
  before(:each) do
    @author = assign(:author, stub_model(Author,
      :firstname => "Firstname",
      :lastname => "Lastname"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Lastname/)
  end
end
