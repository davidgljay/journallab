require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
     describe "when not signed in" do
    
      it "should be successful" do
	get 'home'
        response.should be_success
        response.body.should have_selector('title', :content => "Home")
      end
     end     

     describe "when signed in and a member of a group" do
      before(:each) do
	@group = Factory(:group)
	@user = Factory(:user, :email => Factory.next(:email))
	@group.add(@user)
	@comment = Factory(:comment, :user => @user)
	@paper = Factory(:paper, :pubmed_id => '21228910')
	@paper.buildout([3,3,2,2])
	@fig = @paper.figs.first
	@question = @user.questions.create!(:fig_id => @fig.id, :text => 'A fascinating question!', :form => 'comment')
	@question.set_get_paper
	@group.update_feed
      end

      it "should show the group feed" do
	test_sign_in @user
        get 'home'
	response.body.should include 'Latest Activity'
	response.body.should include @comment.text
	response.body.should include @question.text
      end
     end
    end

		

  describe "GET 'about'" do
    it "should be successful" do
       get 'about'
       response.should be_success
       response.body.should have_selector('title', :content => "About")
     end
   end
    

end
