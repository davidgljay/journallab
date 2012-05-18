require "spec_helper"

describe Mailer do
  describe "comment response" do
    before(:each) do
      @user1 = Factory(:user, :email => Factory.next(:email))
      @user2 = Factory(:user, :email => Factory.next(:email))
      @comment = Factory(:comment)
      @comment.user = @user1
      @reply = @comment.comments.build(:text => "Stampi", :form => "reply")
      @reply.user = @user2
      @reply.save
      @email = Mailer.comment_response(@reply, @user1)
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

   it "should leave a maillog" do
      @email.deliver
      Maillog.last.about.should == @reply
   end

  end

  describe "question response" do
    before(:each) do
      @user1 = Factory(:user, :email => Factory.next(:email))
      @user2 = Factory(:user, :email => Factory.next(:email))
      @question = Factory(:question, :user_id => @user1.id)
      @qcomment = @question.comments.build(:text => "Stampi", :form => "reply")
      @answer = @question.comments.build(:text => "Stampi", :form => "reply")
      @qcomment.user = @user2
      @answer.user = @user2
      @qcomment.save
      @answer.save

    end

    it "should send an e-mail in response to a qcomment" do
      @email = Mailer.comment_response(@qcomment, @user2)
      lambda { @email }.should_not raise_error
      lambda { @email.deliver }.should_not raise_error
      lambda { @email.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end

    it "should send an e-mail in response to an answer" do
      @email = Mailer.comment_response(@answer, @user2)
      lambda { @email }.should_not raise_error
      lambda { @email.deliver }.should_not raise_error
      lambda { @email.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end     
  end

  describe "share notification" do 
    before(:each) do
      
      @user1 = Factory(:user, :email => Factory.next(:email))
      @paper = Factory(:paper)
      @group = Factory(:group)
      @share = @paper.shares.create!(:user => @user1, :get_paper => @paper, :text => 'Check this out!')
      @email = Mailer.share_notification(@share, @user1)
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

    it "should leave a maillog" do
      @email.deliver
      Maillog.last.about.should == @share
    end
  end
end