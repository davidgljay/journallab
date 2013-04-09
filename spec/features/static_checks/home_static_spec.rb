require 'spec_helper'

describe "Visiting the homepage" do

  describe "when not logged in" do

	it "should render the homepage" do
		visit "/"
		within('body') { page.should have_content('Sign In') }
	end
  end

  describe "when logged in" do
	before :each do
		@user = create(:user)
		@user.save
		@paper = create(:paper)
		@paper.lookup_info
		@paper2 = create(:paper)
		@paper2.lookup_info
		integration_sign_in(@user)
	end

	it "should render when the user has no groups or feeds" do
		visit "/"
		within('body') { page.should have_content('Sign Out') }
	end

	it "should render when the user feeds but no groups" do
		f = @user.follows.create!(:search_term => "RNA", :name => "RNA")
    f.update_feed
		f.save
    @user.reload
    @user.set_feedhash
		visit "/"
		within('body') { page.should have_selector('div.follow_' + @user.follows.first.id.to_s) }
	end

	it "should render when the user has groups but no feeds" do
		@group = create(:group)
		@group.add(@user)
		@group.papers << @paper
		d = @group.discussions.first
		d.starttime = Time.now - 1.day
		d.save
    @user.reload
    @user.set_feedhash
		visit "/"
		within('body') { page.should have_content('Test Group') }
	end

	it "should render when the user has multiple groups and feeds" do
		@group = create(:group)
		@group.make_lead(@user)
    @group.reload
    @user.reload
    @group.discuss(@paper, @user)
		@group2 = create(:group, :urlname => 'test2')
    @group2.make_lead(@user)
    @group2.reload
    @user.reload
		@group2.discuss(@paper2, @user)
    @group3 = create(:group, :urlname => 'test3')
		f1 = @user.follows.create!(:search_term => "RNA", :name => "RNA")
    f1.update_feed
		f1.save
		f2 = @user.follows.create!(:search_term => "zombies", :name => "zombies")
		f2.update_feed
    f2.save
    @user.save
    @user.reload
    @user.set_feedhash
    @user.reload
		visit "/"
		within('body') { page.should have_selector('.group' + @group.id.to_s ) }
    within('body') { page.should have_selector('.group' + @group2.id.to_s ) }
    within('body') { page.should_not have_selector('.group' + @group3.id.to_s ) }
		within('body') { page.should have_selector('div.follow_' + @user.follows.first.id.to_s) }
	end
   end

end


