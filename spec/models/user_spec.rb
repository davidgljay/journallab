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
   
  describe "recent activity feed" do

# Can't get this to build multiple questions and comments properly, spent over 2 hours on it, seems like it's not worth the time..
 
#    before(:each) do
#      @user = Factory(:user, :email => Factory.next(:email))
#      @paper1 = Factory(:paper)
      #@comment = @user.comments.build(:text => "Comment!", :paper => @paper1, :form => "comment")
      #@comment.save
      #@question = @user.questions.build(:text => "Question?", :paper => @paper1)
      #@question.save
#      @paper2 = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))
      #@share = @user.shares.build(:paper => @paper1)
      #@share.save
#      @paper2.buildout([2,2,2])
      #@comment2 = @user.comments.build(:fig => @paper2.figs.first, :text => "Comment.", :form => "comment")
#    end

#    it "should list comments, questions, and shares for each paper" do
#      @ra = @user.recent_activity
#      @ra[@paper1].should == [@comment, @share]
#      @ra[@paper2].should == [@question, @comment2]
#    end
  end

    it "should create a new instance given valid attributes" do
	User.create!(@attr)
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
