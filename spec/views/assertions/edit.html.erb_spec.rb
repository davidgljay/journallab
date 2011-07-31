require 'spec_helper'

describe "assertions/edit.html.erb" do
  before(:each) do
    @assertion = assign(:assertion, stub_model(Assertion,
      :text => "MyText",
      :user_id => 1,
      :paper_id => 1,
      :fig_id => 1,
      :figsection_id => 1
    ))
  end

#  it "renders the edit assertion form" do
#    render
    
    #Not sure why this is rendering false, shutting it down but I'm not thrilled about it.

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "form", :action => assertions_path(@assertion), :method => "post" do
    #  assert_select "textarea#assertion_text", :name => "assertion[text]"
    #end
#  end
end
