require 'spec_helper'

describe "papers/show.html.erb" do
  before(:each) do
    @paper = assign(:paper, stub_model(Paper,
      :title => "Title",
      :pubmed_id => 1,
      :journal => "Journal",
      :abstract => "Abstract",
      :summary => "Summary"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Journal/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Abstract/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Summary/)
  end
end
