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
      @user = Factory(:user, :email => Factory.next(:email))
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


end
