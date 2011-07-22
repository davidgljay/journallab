require 'spec_helper'

describe "papers/index.html.erb" do
  before(:each) do
    assign(:papers, [
      stub_model(Paper,
        :title => "Title",
        :pubmed_id => 1,
        :journal => "Journal",
        :abstract => "Abstract",
        :summary => "Summary"
      ),
      stub_model(Paper,
        :title => "Title",
        :pubmed_id => 1,
        :journal => "Journal",
        :abstract => "Abstract",
        :summary => "Summary"
      )
    ])
  end

  it "renders a list of papers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Journal".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Abstract".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "Summary".to_s, :count => 2
  end
end
