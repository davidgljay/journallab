require 'spec_helper'

describe "authors/index.html.erb" do
  before(:each) do
    assign(:authors, [
      stub_model(Author,
        :firstname => "Firstname",
        :lastname => "Lastname"
      ),
      stub_model(Author,
        :firstname => "Firstname",
        :lastname => "Lastname"
      )
    ])
  end

  it "renders a list of authors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
  end
end
