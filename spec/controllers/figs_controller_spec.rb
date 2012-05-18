require 'spec_helper'

describe FigsController do

  describe "GET 'build_sections'" do
    it "should be successful" do
      @paper = Factory(:paper)
      @paper.build_figs(3)
      @fig = @paper.figs.first
      test_sign_in(Factory(:user))
      get 'build_sections', :id => @fig.id.to_s, :num => '3'
      response.should be_success
    end
  end

end
