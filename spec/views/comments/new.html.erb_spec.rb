require 'spec_helper'

describe "comments/new.html.erb" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :text => "MyText",
      :user_id => 1,
      :paper_id => 1,
      :fig_id => 1,
      :figsection_id => 1,
      :comment_id => 1
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path, :method => "post" do
      assert_select "textarea#comment_text", :name => "comment[text]"
      assert_select "input#comment_user_id", :name => "comment[user_id]"
      assert_select "input#comment_paper_id", :name => "comment[paper_id]"
      assert_select "input#comment_fig_id", :name => "comment[fig_id]"
      assert_select "input#comment_figsection_id", :name => "comment[figsection_id]"
      assert_select "input#comment_comment_id", :name => "comment[comment_id]"
    end
  end
end
