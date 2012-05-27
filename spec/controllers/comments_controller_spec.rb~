require 'spec_helper'

describe CommentsController do

  render_views

  describe "create" do

    before(:each) do
      @paper = Factory(:paper)
      @paper.buildout([3,3,2,2])
      @paper.heatmap
      @assertion = Factory(:assertion, :paper => @paper)
      @user1 = Factory(:user, :email => Factory.next(:email))   
      @user2 = Factory(:user, :email => Factory.next(:email))
      @group = Factory(:group)
      @group.add(@user1)
      @group.add(@user2)
      @attr = {:comment => {:text => "Lorem ipsum underpants", :form => "comment", :reply_to => nil, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}, :mode => '2', :owner_id => @paper.id, :owner_class => @paper.class.to_s}
      test_sign_in(@user1)
    end

    it "should create a comment" do
      lambda do
        get :create, @attr
      end.should change(Comment, :count).by(1)
    end

    it "should create a filter state and have the right attributes" do
      get :create, @attr
      @comment = Comment.last
      @comment.filters.first.state.should == 2
      @comment.text.should == "Lorem ipsum underpants"
      @comment.form.should == "comment"
      @comment.assertion.should == @assertion
      @comment.paper.should == @paper
      @comment.user == @user1
    end

    it "should create a reply which triggers an e-mail" do
      get :create, @attr
      @comment = Comment.last
      test_sign_out @user1
      test_sign_in @user2
      @attr[:comment] = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, @attr
      @reply = Comment.last
      @reply.filters.first.state.should == 2
      @reply.text.should == "Lorem ipsum reply"
      @reply.form.should == "reply"
      @reply.assertion.should == @assertion
      @reply.get_paper.should == @paper
      @reply.user == @user2
      Maillog.last.about.should == @reply
    end

    it "should create a qcomment" do
      @question = Factory(:question, :paper => @paper, :assertion => @assertion)
      @attr[:comment] = {:text => "Lorem ipsum reply", :form => "qcomment", :reply_to => @question.id.to_s, :assertion_id => @assertion.id}
      get :create, @attr
      @qcomment = Comment.last
      @qcomment.filters.first.state.should == 2
      @qcomment.text.should == "Lorem ipsum reply"
      @qcomment.form.should == "qcomment"
      @qcomment.assertion.should == @assertion
      @qcomment.get_paper.should == @paper
      @qcomment.user == @user1
      Maillog.last.about.should == @qcomment
    end

    it "should trigger an e-mail to multiple users on a thread" do
      @user3 = Factory(:user, :email => Factory.next(:email))   
      get :create, @attr
      @comment = Comment.last
      test_sign_out @user1
      test_sign_in @user2
      @attr[:comment] = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      get :create, @attr
      test_sign_out @user2
      test_sign_in @user3
      @attr[:comment] = {:text => "Lorem ipsum pancakes", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      get :create, @attr
      Maillog.all.count.should == 3
    end

    it "should not send e-mail to someone who is unsubscribed" do
      @user3 = Factory(:user, :email => Factory.next(:email))   
      @user1.unsubscribe
      @user2.unsubscribe
      @user3.unsubscribe
      get :create, @attr
      @comment = Comment.last
      test_sign_in @user2
      @attr[:comment] = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      get :create, @attr
      test_sign_in @user3
      @attr[:comment] = {:text => "Lorem ipsum pancakes", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      get :create, @attr
      Maillog.all.count.should == 0
    end
   end   

describe "quickform" do

	before(:each) do
		@paper = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))
		@paper.heatmap
		@user1 = Factory(:user, :email => Factory.next(:email)) 
		@user2 = Factory(:user, :email => Factory.next(:email))
		@group = Factory(:group)
		@group.add(@user1)
		@group.add(@user2)
		test_sign_in(@user1)
	end

	it "should create a comment for a figure" do
		@attr = {:text => "Lorem ipsum underpants", :form => "comment", :paper => @paper.id, :fig => "3", :mode => '1'}
		get :quickform, @attr
		@paper = Paper.find(@paper.id)
		@comment = Comment.last
		@comment.owner.should == @paper.figs[2]
		@comment.text.should == "Lorem ipsum underpants"
		@comment.user.should == @user1
		@group.filter_state(@comment) == 1
	end

	it "should create a comment for a paper" do
		@attr = {:text => "Lorem ipsum underpants", :form => "comment", :paper => @paper.id, :fig => '', :mode => '2'}
		get :quickform, @attr
		@paper = Paper.find(@paper.id)
		@comment = Comment.last
		@comment.owner.should == @paper
		@comment.text.should == "Lorem ipsum underpants"
		@comment.user.should == @user1
		@group.filter_state(@comment) == 2
	end

	it "should create a comment for a section" do
		@attr = {:text => "Lorem ipsum underpants", :form => "comment", :paper => @paper.id, :fig => "3d", :mode => '3'}
		get :quickform, @attr
		@paper = Paper.find(@paper.id)
		@paper.figs.count.should == 3
		@comment = Comment.last 
		@comment.owner.should == @paper.figs[2].figsections[3]
		@comment.text.should == "Lorem ipsum underpants"
		@comment.user.should == @user1
		@group.filter_state(@comment) == 3
	end

end


end
