require 'spec_helper'

describe NotesController do

  describe "GET 'create' and DELETE 'destroy'" do

	before(:each) do
		@paper = create(:paper)
		@user = create(:user)
		@folder = @user.folders.first
		test_sign_in(@user)
	end

    it "should be successful" do
		get 'create', :note => {:about_id => @paper.id.to_s, :about_type => 'Paper', :text => "Fascinating!", :folder_id => @folder.id}
		assigns(:note).user.should == @user
		assigns(:note).id.should_not be_nil

    end

    it "should destroy successfully" do
		get 'create', :note => {:about_id => @paper.id.to_s, :about_type => 'Paper', :text => "Fascinating!", :folder_id => @folder.id}
		delete 'destroy', {:folder_id => @folder.id.to_s, :paper_id => @paper.id.to_s} 
		@folder.notes.select{|n| n.about == @paper}.empty?.should be_true
    end
  end

end
