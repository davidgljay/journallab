require 'spec_helper'

describe "Questions:" do

   before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @paper.buildout([3,3,2,1])
     @user2 = Factory(:user, :email => Factory.next(:email))  
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

   describe "posting a Question" do
      it "adds a Question to a paper and lets you reply", :js => true do
       click_button "Add a Question"
       fill_in 'question_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm commenting."
       click_button 'Submit' 
       find('li.answerlink').click
       fill_in 'question_text', :with => "Here's an answer to your question."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm commenting.")
       page.should have_content("Here's an answer to your question.")
       page.should have_content(@user.firstname)
       click_link 'Sign out'
       visit '/signin'
       fill_in "session_email", :with => @user2.email
       fill_in "session_password", :with => @user2.password
       click_button "Sign in"
       visit '/papers/' + @paper.id.to_s
       click_button 'vote_submit'
       page.should have_content("1 Nod")
       page.should have_css("img", :src => "/images/voted.png") 
      end
   end

     it "adds a Question to a figure and lets you reply", :js => true do
       find('#fig1').click_button "Add a Question"
       fill_in 'question_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm commenting."
       click_button 'Submit' 
       find('li.answerlink').click
       fill_in 'question_text', :with => "Here's an answer to your question."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm commenting.")
       page.should have_content("Here's an answer to your question.")
     end

     it "adds a Question to a figure section and lets you reply", :js => true do
       find('div.figtoggle').click
       find('#figsection1').click_button "Add a Question"
       fill_in 'question_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm commenting."
       click_button 'Submit' 
       find('li.answerlink').click
       fill_in 'question_text', :with => "Here's an answer to your question."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm commenting.")
       page.should have_content("Here's an answer to your question.")
     end

end
