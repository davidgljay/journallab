require 'spec_helper'

describe "assertions/new.html.erb" do
  before(:each) do
    assign(:assertion, stub_model(Assertion,
      :text => "MyText",
      :user_id => 1,
      :paper_id => 1,
      :fig_id => 1,
      :figsection_id => 1
    ).as_new_record)
  end

  it "renders new assertion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assertions_path, :method => "post" do
      assert_select "textarea#assertion_text", :name => "assertion[text]"
      assert_select "input#assertion_user_id", :name => "assertion[user_id]"
      assert_select "input#assertion_paper_id", :name => "assertion[paper_id]"
      assert_select "input#assertion_fig_id", :name => "assertion[fig_id]"
      assert_select "input#assertion_figsection_id", :name => "assertion[figsection_id]"
    end
  end
end
