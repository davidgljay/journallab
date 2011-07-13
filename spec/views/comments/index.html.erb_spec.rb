require 'spec_helper'

describe "comments/index.html.erb" do
  before(:each) do
    assign(:comments, [
      stub_model(Comment,
        :text => "MyText",
        :user_id => 1,
        :paper_id => 1,
        :fig_id => 1,
        :figsection_id => 1,
        :comment_id => 1
      ),
      stub_model(Comment,
        :text => "MyText",
        :user_id => 1,
        :paper_id => 1,
        :fig_id => 1,
        :figsection_id => 1,
        :comment_id => 1
      )
    ])
  end

end
