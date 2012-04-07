require "spec_helper"

describe Mailer do
  describe "comment response" do
    before(:each) do
      @user1 = Factory(:user, :email => Factory.next(:email))
      @user2 = Factory(:user, :email => Factory.next(:email))
      @comment = Factory(:comment, :user => @user1)
      @reply = @comment.comments.build(:text => "Stampi", :form => "reply")
      @reply.user = @user2
      @reply.save
      @email = Mailer.comment_response(@reply)
    end
 
    it "should render and deliver successfully an e-mail" do
      lambda { @email }.should_not raise_error
      lambda { @email.deliver }.should_not raise_error
      lambda { @email.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end
      
    it "should include the paper title" do
      @email.subject.should include @comment.get_paper.title
      @email.body.parts[0].body.should include @comment.get_paper.title
      @email.body.parts[1].body.should include @comment.get_paper.title
    end

    it "should include the commentor name" do
      @email.body.parts[0].body.should include @user2.name
      @email.body.parts[1].body.should include @user2.name
    end

    it "should include the comment text" do
      @email.body.parts[0].body.should include "Stampi"
      @email.body.parts[1].body.should include "Stampi"
    end

  end

  describe "share notification" do 
    before(:each) do
      @user1 = Factory(:user, :email => Factory.next(:email))
      @paper = Factory(:paper)
      @group = Factory(:group)
      @group.add(@user1)
      @share = @user1.share!(@paper)
      @email = Mailer.share_notification(@share)
    end

    it "should render and deliver successfully an e-mail" do
      lambda { @email }.should_not raise_error
      lambda { @email.deliver }.should_not raise_error
      lambda { @email.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end

    it "should include the paper title" do
      @email.body.parts[0].body.should include @paper.title
      @email.body.parts[1].body.should include @paper.title
    end

  end
end
