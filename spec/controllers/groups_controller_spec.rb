require 'spec_helper'

describe GroupsController do

	describe "removing users" do 
		before(:each) do
			@group = create(:group)
			@lead = create(:user)
			@newuser = create(:user)
			@group.add(@lead)
			@group.make_lead(@lead)
			@group.add(@newuser)
		end

		it "should not remove if not logged in as a group lead" do
			get :remove, {:id => @group.id, :u_id => @newuser.id }
			@newuser.member_of?(@group).should be true
		end

		
		it "should remove a user" do
			test_sign_in(@lead)
			@newuser.id.should_not be_nil
			get :remove, {:id => @group.id, :u_id => @newuser.id }
			@newuser.member_of?(@group).should be false
			response.should redirect_to root_path 
		end
	end

  describe "discussing and undiscussing papers" do
    before(:each) do
      @group = create(:group)
      @lead = create(:user)
      @group.add(@lead)
      @group.make_lead(@lead)
      @paper = create(:paper)
    end

    it "should discuss a paper" do
      test_sign_in(@lead)
      get :discuss, {:id => @group.id, :paper_id => @paper.id}
      @group.discussions.last.paper.should == @paper
    end

    it "should undiscuss a paper" do
      test_sign_in(@lead)
      @group.discuss(@paper,@lead)
      get :undiscuss, {:id => @group.id, :paper_id => @paper.id}
      @group.papers.include?(@paper).should be_false
    end

  end

  describe "joining and leaving a group" do
    before(:each) do
      @group = create(:group)
      @user= create(:user)
    end

    it "should let a user join" do
      test_sign_in(@user)
      get :join, {:id => @group.id}
      @group.reload
      @group.users.should include @user
    end

    it "should let a user leave" do
      @group.add(@user)
      test_sign_in(@user)
      get :leave, {:id => @group.id}
      @group.reload
      @group.users.include?(@user).should be_false
    end

  end

end
