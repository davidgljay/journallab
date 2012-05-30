require 'spec_helper'

describe GroupsController do

	describe "removing users" do 
		before(:each) do
			@group = Factory(:group)
			@lead = Factory(:user, :email => Factory.next(:email))
			@newuser = Factory(:user, :email => Factory.next(:email))
			@group.add(@lead)
			@group.make_lead(@lead)
			@group.add(@newuser)
		end

		it "should not remove if not logged in as a group lead" do
			get :remove, {:id => @group.id, :user => @newuser.id }
			@newuser.member_of?(@group).should be true
		end

		
		it "should remove a user" do
			test_sign_in(@lead)
			@newuser.id.should_not be_nil
			get :remove, {:id => @group.id, :user => @newuser.id }
			@newuser.member_of?(@group).should be false
			response.should redirect_to root_path 
		end
	end

end
