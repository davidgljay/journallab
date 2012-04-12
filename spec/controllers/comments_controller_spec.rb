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
      @attr = {:text => "Lorem ipsum underpants", :form => "comment", :reply_to => nil, :assertion_id => @assertion.id}
      test_sign_in(@user1)
    end

    it "should create a comment" do
      lambda do
        get :create, :comment => @attr, :mode => '2'
      end.should change(Comment, :count).by(1)
    end

    it "should create a filter state and have the right attributes" do
      get :create, :comment => @attr, :mode => '2'
      @comment = Comment.last
      @comment.filters.first.state.should == 2
      @comment.text.should == "Lorem ipsum underpants"
      @comment.form.should == "comment"
      @comment.assertion.should == @assertion
      @comment.paper.should == @paper
      @comment.user == @user1
    end

    it "should create a reply which triggers an e-mail" do
      get :create, :comment => @attr, :mode => '2'
      @comment = Comment.last
      test_sign_in @user2
      @attr = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
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
      @attr = {:text => "Lorem ipsum reply", :form => "qcomment", :reply_to => @question.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
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
      get :create, :comment => @attr, :mode => '2'
      @comment = Comment.last
      test_sign_in @user2
      @attr = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
      test_sign_in @user3
      @attr = {:text => "Lorem ipsum pancakes", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
      Maillog.all.count.should == 3
    end

    it "should not send e-mail to someone who is unsubscribed" do
      @user3 = Factory(:user, :email => Factory.next(:email))   
      @user1.unsubscribe
      @user2.unsubscribe
      @user3.unsubscribe
      get :create, :comment => @attr, :mode => '2'
      @comment = Comment.last
      test_sign_in @user2
      @attr = {:text => "Lorem ipsum reply", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
      test_sign_in @user3
      @attr = {:text => "Lorem ipsum pancakes", :form => "reply", :reply_to => @comment.id.to_s, :assertion_id => @assertion.id}
      get :create, :comment => @attr, :mode => '2'
      Maillog.all.count.should == 0
    end
   end   
end
