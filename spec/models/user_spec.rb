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
      @group.category = 'jclub'
      @group.save
      @group.add(@user)
      @group.discuss(@paper, @user)
      @user.reload
    end

    it "should generate a hash of the users feeds, including follows and groups" do
      @user.set_feedhash
      @group.users.count.should == 1
      @user.groups.first.category.should == 'jclub'
      @user.feedhash[0][:name].should == 'test'
      @user.feedhash[0][:css_class].should == @f.css_class
      @user.feedhash[0][:newcount].should == 0
      @user.feedhash[1][:type].should == 'group'
    end
  end

end
