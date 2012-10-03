require 'spec_helper'

describe "/" do

  describe "when not logged in" do

	it "should render the homepage" do
		visit "/"
		within('body') { page.should have_content('Sign In') }
	end
  end

  describe "when logged in" do
	before :each do
		@user = Factory(:user, :email => Factory.next(:email))
		@user.save
		@paper = Factory(:paper)
		@paper.lookup_info
		@paper2 = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))
		@paper2.lookup_info
		integration_sign_in(@user)
	end

	it "should render when the user has no groups or feeds" do
		visit "/"
		within('body') { page.should have_content('Sign Out') }
	end

	it "should render when the user feeds but no groups" do
		f = @user.follows.create!(:search_term => "RNA", :name => "RNA")
		f.save
		visit "/"
		within('body') { page.should have_selector('input.follow_' + @user.follows.first.id.to_s) }
	end

	it "should render when the user has groups but no feeds" do
		@group = Group.create(:name => "Test Group", :category => "jclub")
		@group.add(@user)
		@group.papers << @paper
		d = @group.discussions.first
		d.starttime = Time.now - 1.day
		d.save		
		visit "/"
		within('body') { page.should have_content('Test Group') }
	end

	it "should render when the user has multiple groups and feeds" do
		@group = Group.create(:name => "Test Group", :category => "jclub")
		@group.add(@user)
		@group.papers << @paper
		d = @group.discussions.first
		d.starttime = Time.now - 1.day
		d.save		
		@group = @user.groups.create(:name => "Sample Group", :category => "jclub")
		@group.papers << @paper2
		f1 = @user.follows.create!(:search_term => "RNA", :name => "RNA")
		f1.save
		f2 = @user.follows.create!(:search_term => "zombies", :name => "zombies")
		f2.save
		visit "/"
		within('body') { page.should have_selector('.group' + @group.id.to_s ) }
		within('body') { page.should have_selector('input.follow_' + @user.follows.first.id.to_s) }
	end
   end

end


