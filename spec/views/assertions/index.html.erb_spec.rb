require 'spec_helper'

describe "assertions/index.html.erb" do
  before(:each) do
    assign(:assertions, [
      stub_model(Assertion,
        :text => "MyText",
        :user_id => 1,
        :paper_id => 1,
        :fig_id => 1,
        :figsection_id => 1
      ),
      stub_model(Assertion,
        :text => "MyText",
        :user_id => 1,
        :paper_id => 1,
        :fig_id => 1,
        :figsection_id => 1
      )
    ])
  end


end
