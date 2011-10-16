require 'spec_helper'

describe "Comments:" do

   before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @paper.buildout([3,3,2,1])
     @user2 = Factory(:user, :email => Factory.next(:email))  
     @paper.figs.each do |f|
       a = f.assertions.build(:text => "Test", :method => "Test test", :ispublic => true)
       a.user = @user
       a.save
       f.figsections.each do |s|
          a = s.assertions.build(:text => "Test", :method => "Test test", :ispublic => true)
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

   describe "posting a comment" do
      it "adds a comment to a paper and lets you reply", :js => true do
       click_button "Add a Comment"
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       click_button "1 Comment"
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       click_button '1 Comment'
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
       page.should have_content(@user.firstname)
       click_link 'Sign out'    
       visit '/papers/' + @paper.id.to_s
       click_button '1 Comment'
       page.should have_content(@user.anon_name)
      end
   end

     it "adds a comment to a figure and lets you reply", :js => true do
       find('#fig1').click_button "Add a Comment"
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       click_button "1 Comment"
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       click_button '1 Comment'
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
     end

     it "adds a comment to a figure section and lets you reply", :js => true do
       find('td.figtoggle').click
       find('#section1').click_button "Add a Comment"
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('td.figtoggle').click
       find('#section1').click_button "1 Comment"
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       find('td.figtoggle').click
       find('#section1').click_button '1 Comment'
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
     end

end
