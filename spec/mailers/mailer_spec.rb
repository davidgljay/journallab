require "spec_helper"

describe Mailer do
  describe "comment response" do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @comment = create(:comment)
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
      @user1 = create(:user)
      @user2 = create(:user)
      @question = create(:question, :user_id => @user1.id)
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
      @user1 = create(:user)
      @paper = create(:paper)
      @group = create(:group)
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

  describe "group add notification" do
    before(:each) do
	@user1 = create(:user)
	@user2 = create(:user)
	@group = create(:group)
	@group.add(@user1)
	@group.make_lead(@user1)
	@email = Mailer.group_add_notification(@group, @user1, @user2)
    end

    it "should render and deliver successfully an e-mail" do
      lambda { @email }.should_not raise_error
      lambda { @email.deliver }.should_not raise_error
      lambda { @email.deliver }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end

    it "should deliver an e-mail to the leader of the group" do
	@email.to.should == [@user1.email]
	
    end

    it "should include the name of the new member and of the group" do
      @email.body.parts[0].body.should include @user1.name
      @email.body.parts[1].body.should include @user1.name
      @email.body.parts[0].body.should include @group.name
      @email.body.parts[1].body.should include @group.name
    end

    it "should leave a maillog" do
      @email.deliver
      Maillog.last.about.should == @group
    end

  end

  if false #disabling until shares are re-enabled.
  describe "share digest" do
	it "should send a share digest" do
		@user1 = create(:user)
		@user2 = create(:user)
		@group = create(:group)
		@group.add(@user1)
		@group.add(@user2)
		@paper = create(:paper)
		@fig = @paper.figs.first
		@share1 = @paper.shares.create!(:user => @user1, :group => @group, :text => "Check out this paper.")
		@share2 = @fig.shares.create!(:user => @user2, :group => @group, :text => "Check out this figure.")
		@share1.set_get_paper
		@share2.set_get_paper
		@email = Mailer.share_digest(@user1)
		@email.body.parts[0].body.should include @user1.name
		@email.body.parts[1].body.should include @user1.name
		@email.body.parts[0].body.should include @user2.name
		@email.body.parts[1].body.should include @user2.name
		@email.body.parts[0].body.should include @share1.text
		@email.body.parts[1].body.should include @share1.text
		@email.body.parts[0].body.should include @share2.text
		@email.body.parts[1].body.should include @share2.text
      		@email.deliver
		Maillog.last.about.should == @share1
	end
  end
    end

end
