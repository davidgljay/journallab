require 'spec_helper'

describe "Users" do
  describe "GET /user/1" do
    before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @paper.pubdate = Time.now - 5.years
     @paper.save
     @paper.buildout([3,3,2,1])
     @group = Factory(:group)
     @group.add(@user)
     a = @paper.assertions.build(:text => "Test", :method => "Test test")
     a.is_public = true
     a.user = @user
     a.save
     @paper.figs.each do |f|
       a = f.assertions.build(:text => "Test", :method => "Test test")
       a.is_public = true
       a.user = @user
       a.save
       f.figsections.each do |s|
          a = s.assertions.build(:text => "Test", :method => "Test test")
          a.is_public = true
          a.user = @user2
          a.save
       end
     end    
     @comment = @paper.comments.build(:text => "comment")
     @comment.user = @user
     @comment.save
     @question = @paper.questions.build(:text => "comment")
     @question.user = @user
     @question.save
     v = @user.visits.build(:paper => @paper, :count => 1)
     v.save
       visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
     visit '/users/' + @user.id.to_s
     end

     it "should render the user profile", :js => true do
        within('h2') { page.should have_content(@user.name) }
        find('#position').click
        fill_in "user[position]", :with => "stuff and things"
        find('#user_position').native.send_key(:enter)
	page.should have_content("stuff and things")
     end
  end

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "First Name",    :with => ""
          fill_in "Last Name",     :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button 'Sign up'
          within('div#error_explanation') { page.should have_content('Password') }

        end
      end
     end
    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "First Name",    :with => "Example"
          fill_in "Last Name",     :with => "User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button 'Sign up'
          within('div.flash.success') { page.should have_content('Welcome') }
        end
      end
     end
    end
end
