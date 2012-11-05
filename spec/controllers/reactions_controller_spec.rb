require 'spec_helper'

describe ReactionsController do


  describe "GET 'create'" do
    before(:each) do
      @paper = create(:paper)
      @paper.build_figs(3)
      @fig = @paper.figs.first
      @user = create(:user)
      test_sign_in(@user)
    end

    it "should be successful and flag @newreaction as true" do
      get 'create', :about_id => @fig.id.to_s, :about_type => 'Fig', :reaction => {:user_id => @user, :name => "Solid Science"}
      assigns(:newreaction).should == true
    end

    it "should fail if that user has already given that reaction" do
      @fig.reactions.create(:name => "Solid Science", :user => @user)
      get 'create', :about_id => @fig.id.to_s, :about_type => 'Fig', :reaction => {:user_id => @user, :name => "Solid Science"}
      assigns(:newreaction).should == false
    end
  end

end
