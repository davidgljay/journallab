require 'spec_helper'

describe "Comments:" do

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
     @fig = @paper.figs.first
     @figsection = @fig.figsections.first
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

   describe "posting a comment" do
      it "adds a comment to a paper and lets you reply", :js => true do
       find('form.commentlist').click
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
       page.should have_content(@user.firstname)
       end

     it "adds a comment to a figure and lets you reply", :js => true do
       find('#fig' + @fig.id.to_s).find('form.commentlist').click
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
     end

     it "adds a comment to a figure section and lets you reply", :js => true do
       find('div.figtoggle').click
       find('#fig_1_sections').find('#figsection' + @figsection.id.to_s ).find('form.commentlist').click
       fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       click_button 'Submit' 
       find('li.replylink').click
       fill_in 'comment_text', :with => "That's so smart I'm replying."
       click_button 'Submit' 
       page.should have_content("I have an incredibly intelligent thing to say.")
       page.should have_content("That's so smart I'm replying.")
     end

     describe "through the quickform" do

	it "adds a comment to a figure", :js => true do
		find('a.quick_comment').click
		find('input#fig').click
		fill_in 'input#fig' '3'
		fill_in 'text' "I have an incredibly intelligent thing to say."
		click_button 'Submit' 
		page.should have_content("I have an incredibly intelligent thing to say.")
	end
      end
  end
end
