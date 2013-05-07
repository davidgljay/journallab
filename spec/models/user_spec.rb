require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :firstname => "Example",
        :lastname => "User",
        :email => "user@example.com",
        :password => "funstuff",
        :password_confirmation => "funstuff"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should automatically create a To Read folder" do
    @user = User.create!(@attr)
    @user.folders.map{|f| f.name}.should include "To Read"
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:firstname => "", :lastname => ''))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email =>""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:firstname => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should certify users with a .edu address" do
    user = User.create!(@attr.merge(:email => 'example@school.edu'))
    user.certified.should be_true
  end

  it "should certify users with a nih.gov address" do
    user = User.create!(@attr.merge(:email => 'example@nih.gov'))
    user.certified.should be_true
  end

  it "should not certify users with a .com address" do
    user = User.create!(@attr)
    user.certified.should be_false
  end

  it "should automatically create a set of subscriptions" do
    user = User.create!(@attr)
    user.subscription_map.should include 'weekly'
  end

  it "should automatically create a set of subscriptions" do
    user = User.create!(@attr)
    s = user.subscriptions.first
    s.receive_mail = false
    s.save
    user.save
    user.subscriptions.first.receive_mail.should be_false
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "unsubscribe functionality" do

    before(:each) do
      @user = create(:user)
    end

    it "should record an unsubscribe" do
      @user.unsubscribe
      @user.subscriptions.first.receive_mail.should == false
    end

    it "should know when someone is unsubscribed" do
      @user.unsubscribe
      @user.receive_mail? == false
    end

    it "should know when someone is not unsubscribed" do
      @user.receive_mail? == true
    end
  end

  describe "feedhash functionality" do
    before(:each) do
      @user = create(:user)
      @f = @user.follows.create!(:name => "test", :search_term => "test", :follow_type => "pubmed_search")
      @paper = create(:paper)
      @group = create(:group)
      @group.save
      @group.make_lead(@user)
      @user.reload
      @group.reload
      @group.discuss(@paper, @user)
      @user.save
      @user.reload
    end

    it "should generate a hash of the users feeds, including follows and groups" do
      @user.set_feedhash
      @group.users.count.should == 1
      @user.groups.first.category.should == 'jclub'
      @group.current_discussion.nil?.should be_false
      @user.feedhash[1].nil?.should be_false
      @user.feedhash[0][:name].should == 'test'
      @user.feedhash[0][:css_class].should == @f.css_class
      @user.feedhash[0][:newcount].should == 0
      @user.feedhash[1][:type].should == 'group'
    end
  end

  describe "orientation" do

    it "should take a user through the orientation process" do
    @user = create(:user)
    @user.check_orientation
    @user.reload
    @user.orientationhash[:complete].should == 5
    @user.orientationhash[:step].should == 0

    # Step 1: Create 5 feeds
    2.times do
      create(:follow, :user => @user)
    end
    @user.check_orientation.should be_true
    @user.reload
    @user.orientationhash[:complete].should == 15
    @user.orientationhash[:step].should == 0
    3.times do
      create(:follow, :user => @user)
    end
    @user.check_orientation.should be_true
    @user.reload
    @user.orientationhash[:step].should == 1

    #Step 2: Join a Journal Club
    @group = create(:group)
    @group.add(@user)
    @user.check_orientation.should be_true
    @user.reload
    @user.orientationhash[:complete].should == 35
    @user.orientationhash[:step].should == 2

    #Step 3: Complete your profile
    @user.image_url = "http://s3.amazonaws.com/j.lab-images/static/florie.jpg"
    @user.institution = "University of Rocks"
    @user.position = "Stampisaur"
    @user.save
    @user.check_orientation.should be_true
    @user.reload
    @user.orientationhash[:complete].should == 55
    @user.orientationhash[:step].should == 3

    #Step 4: Enter a comment
    @paper = create(:paper)
    @reaction = create(:reaction, :about => @paper, :user => @user)
    @user.check_orientation
    @user.reload
    @user.orientationhash[:complete].should == 75
    @user.orientationhash[:step].should == 4

    #Step 5: Enter a Summary
    @summary = create(:assertion, :user => @user)
    @user.check_orientation
    @user.reload
    @user.orientationhash[:complete].should == 100
    @user.orientationhash[:step].should == 5
    @user.check_orientation.should be_false
    end

  end

  describe "relevant discussions" do

    before (:each) do
      @user = create(:user)
      @paper1 = create(:paper, :title => 'Zebrafish')
      @paper2 = create(:paper, :title => 'Zombies')
      @comment1 = create(:comment, :paper => @paper1)
      @comment2 = create(:comment, :paper => @paper2)
      create(:reaction, :about => @paper1)
      create(:reaction, :about => @paper1)
      create(:reaction, :about => @paper1)
      create(:reaction, :about => @paper2)
      create(:reaction, :about => @paper2)
      create(:reaction, :about => @paper2)
    end

    it "should add a discussion from a paper that the user has visited" do
      @user.visits.create(:about_id => @paper1.id, :about_type => 'Paper', :visit_type => 'paper')
      @user.save
      @user.reload
      @user.set_recent_discussions
      @user.visits.count.should == 1
      @user.visits.map{|v| v.about}.first.should == @paper1
      @user.recent_discussions.map{|p| p[:paper_id]}.should include @paper1.id
      @user.recent_discussions.map{|p| p[:paper_id]}.should_not include @paper2.id
    end

    it "should add a discussion from the user's feeds" do
      @user.follows.create(:search_term => @paper2.title, :name => @paper2.title)
      @comment2.feedify
      @user.save
      @user.reload
      @user.set_recent_discussions
      @user.recent_discussions.map{|p| p[:paper_id]}.should include @paper2.id
      @user.recent_discussions.map{|p| p[:paper_id]}.should_not include @paper1.id
    end

    it "should add recent_discussions to fill any remaining slots" do
      Analysis.new.recent_discussions
      a = Analysis.find_by_description('recent_discussions')
      a.nil?.should be_false
      a.cache.count
      @user.set_recent_discussions
      @user.recent_discussions.count.should > 0
      @user.recent_discussions.map{|p| p[:paper_id]}.should include @paper2.id
      @user.recent_discussions.map{|p| p[:paper_id]}.should include @paper1.id
    end

  end

end
