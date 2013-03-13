require 'spec_helper'

describe MediaController do

  describe "GET 'create'" do

    before :each do
      @user = create(:user)
      @paper = create(:paper)
      test_sign_in (@user)
    end

    it "should create a youtube video attached to the paper" do
      @link = 'http://www.youtube.com/watch?v=oHg5SJYRHA0'
      get 'create', :paper => @paper.id.to_s, :link => @link
      response.should redirect_to @paper
      assigns(:media).category.should == 'youtube'
      flash[:success].should_not be_nil
    end

    it "should create a slideshare deck attached to the paper" do
      @link = 'http://www.slideshare.net/jessedee/100-beautiful-slides-from-the-cannes-lions-festival-of-creativity-2012'
      get 'create', :paper => @paper.id.to_s, :link => @link
      response.should redirect_to @paper
      assigns(:media).category.should == 'slideshare'
      flash[:success].should_not be_nil
    end

    it "should create an invalid media object and display an error" do
      @link = 'http://www.journallab.org'
      get 'create', :paper => @paper.id.to_s, :link => @link
      response.should redirect_to @paper
      assigns(:media).category.should == 'invalid'
      flash[:error].should_not be_nil
    end
  end

end
