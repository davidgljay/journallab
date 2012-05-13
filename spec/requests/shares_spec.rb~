require 'spec_helper'

describe "Shares:" do

 before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @paper.buildout([3,3,2,1])
     @user2 = Factory(:user, :email => Factory.next(:email))
     @group = Factory(:group)
     @group.add(@user)
     @group.add(@user2)  
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
     visit '/signin'
     fill_in "session_email", :with => @user.email
     fill_in "session_password", :with => @user.password
     click_button "Sign in"
     visit '/papers/' + @paper.id.to_s
   end

  it "shares a paper.", :js => true do
      find('#paper' + @paper.id.to_s ).find('li.sharelink').click
      fill_in 'share_text', :with => "This is the bees stripes."
      click_button 'Share with your lab'
      page.should have_content("Shared!")
      @group.feed.first.paper.should == @paper
  end

end
