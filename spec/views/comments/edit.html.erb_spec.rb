require 'spec_helper'

describe "comments/edit.html.erb" do
  before(:each) do
    @comment = Factory(:comment)
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path(@comment), :method => "post" do
      assert_select "textarea#comment_text", :name => "comment[text]"
    end
  end
end
