require 'spec_helper'

describe QuestionsController do

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
      @attr = {:text => "Lorem ipsum underpants", :format => "question", :reply_to => nil, :assertion_id => @assertion.id}
      test_sign_in(@user1)
    end

    it "should create a question" do
      lambda do
        get :create, :question => @attr, :mode => '2'
      end.should change(Question, :count).by(1)
    end

    it "should create a filter state and have the right attributes" do
      get :create, :question => @attr, :mode => '2'
      @question = Question.last
      @question.filters.first.state.should == 2
      @question.text.should == "Lorem ipsum underpants"
      @question.assertion.should == @assertion
      @question.paper.should == @paper
      @question.user == @user1
    end

    it "should create a reply which triggers an e-mail" do
      get :create, :question => @attr, :mode => '2'
      @question = Question.last
      test_sign_in @user2
      @attr = {:text => "Lorem ipsum reply", :format => "answer", :reply_to => @question.id, :assertion_id => @assertion.id}
      get :create, :question => @attr, :mode => '2'
      @answer = Question.last
      @answer.filters.first.state.should == 2
      @answer.text.should == "Lorem ipsum reply"
      @answer.assertion.should == @assertion
      @answer.get_paper.should == @paper
      @answer.user == @user2
      Maillog.last.about.should == @answer
      Maillog.all.count.should == 1
    end

    it "should trigger an e-mail to multiple users on a thread" do
      @user3 = Factory(:user, :email => Factory.next(:email))   
      get :create, :question => @attr, :mode => '2'
      @question = Question.last
      test_sign_in @user2
      @attr = {:text => "Lorem ipsum answer", :format => "answer", :reply_to => @question.id.to_s, :assertion_id => @assertion.id}
      get :create, :question => @attr, :mode => '2'
      test_sign_in @user3
      @attr = {:text => "Lorem ipsum pancakes", :format => "answer", :reply_to => @question.id.to_s, :assertion_id => @assertion.id}
      get :create, :question => @attr, :mode => '2'
      Maillog.all.count.should == 3
    end

   end   
end
