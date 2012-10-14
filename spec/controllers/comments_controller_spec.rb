require 'spec_helper'

describe CommentsController do

  render_views

  describe "create" do

    before(:each) do
      @paper = create(:paper)
      @paper.buildout([3,3,2,2])
      @paper.heatmap
      @assertion = create(:assertion, :paper => @paper)
      @user1 = create(:user)   
      @user2 = create(:user)
      @group = create(:group)
      @group.add(@user1)
      @group.add(@user2)
      @attr = {:comment => {:text => "Lorem ipsum underpants", :form => "comment", :reply_to => nil, :assertion_id => @assertion.id, :owner_id => @paper.id, :owner_type => @paper.class.to_s}, :mode => '2', :owner_id => @paper.id, :owner_class => @paper.class.to_s}
      test_sign_in(@user1)
    end

    it "should create a comment" do
      lambda do
        get :create, @attr
	#@group.reload.feed.first[:item_type].should == "Comment"
      end.should change(Comment, :count).by(1)
    end

    it "should create a filter state and have the right attributes" do
      get :create, @attr
      @comment = Comment.last
      #@comment.filters.first.state.should == 2
      @comment.text.should == "Lorem ipsum underpants"
      @comment.form.should == "comment"
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
      #@reply.filters.first.state.should == 2
      @reply.text.should == "Lorem ipsum reply"
      @reply.form.should == "reply"
      @reply.get_paper.should == @paper
      @reply.user == @user2
      Maillog.last.about.should == @reply
    end


    it "should trigger an e-mail to multiple users on a thread" do
      @user3 = create(:user)   
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
      @user3 = create(:user)   
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



end
