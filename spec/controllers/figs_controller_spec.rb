require 'spec_helper'

describe FigsController do

  describe "GET 'build_sections'" do
    it "should be successful" do
      @paper = create(:paper)
      @paper.build_figs(3)
      @fig = @paper.figs.first
      @user = create(:user)
      test_sign_in(@user)
      get 'build_sections', :id => @fig.id.to_s, :num => '3'
      @fig.figsections.count.should == 3
      response.should redirect_to @paper
    end
  end

end
