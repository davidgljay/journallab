require 'spec_helper'

describe "Reactions" do
   before(:each) do
	@user = Factory(:user, :email => Factory.next(:email))
	@paper = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))
     	@paper.authors << Factory(:author)
	@group = Factory(:group)
	@paper.lookup_info
	@paper.extract_authors
	@group.add(@user)
	@paper.buildout([3,3,2,1])
	@fig = @paper.figs.first
	@figsection = @fig.figsections.first
        visit '/users/sign_in'
        fill_in "user_email", :with => @user.email
        fill_in "user_password", :with => @user.password
        click_button "Sign in"
        visit '/papers/' + @paper.id.to_s
   end

   it "should register a reaction through the quickform", :js => true do
	find('.quickform').click_button('Solid Science')
	page.should have_css('li.reactionlink.badge-success')
	find('quickform').fill_in 'name', :with => 'Timey Wimey'
	find('quickform').click_button 'Submit'
	#page.should have_content('Timey Wimey')
	fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
	#click_box 'anonymous'
       	click_button 'Submit'
       	find('li.replylink').click 
	fill_in 'comment_text', :with => "That's so smart I'm replying."
       	find('form.new_comment').click_button 'Submit' 
       	page.should have_content("I have an incredibly intelligent thing to say.")
       	page.should have_content("That's so smart I'm replying.")
       	page.should have_content(@user.firstname)
       	page.should have_content('Anonymous')
   end



   it "should register a reaction to a paper", :js => true do
	find('#paper' + @paper.id.to_s).click_button('Solid Science')
	page.should have_css('li.reactionlink.badge-success')
	find('#paper' + @paper.id.to_s).fill_in 'reaction_name', :with => 'Timey Wimey'
	find('#paper' + @paper.id.to_s).click_button 'Submit'
	#page.should have_content('Timey Wimey')
	fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
       	click_button 'Submit'
       	find('li.replylink').click 
	fill_in 'comment_text', :with => "That's so smart I'm replying."
       	find('form.new_comment').click_button 'Submit' 
       	page.should have_content("I have an incredibly intelligent thing to say.")
       	page.should have_content("That's so smart I'm replying.")
       	page.should have_content(@user.firstname)
       	page.should have_content('Anonymous')
   end

   it "should register a reaction to a figure", :js => true do
	find('#fig' + @fig.id.to_s).click_button('Solid Science')
	page.should have_css('li.reactionlink.badge-success')
	find('#fig' + @fig.id.to_s).fill_in 'reaction_name', :with => 'Timey Wimey'
	find('#fig' + @fig.id.to_s).click_button 'Submit'
	#page.should have_content('Timey Wimey')
	fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
	#check_box 'anonymous'
       	click_button 'Submit'
       	find('li.replylink').click 
	fill_in 'comment_text', :with => "That's so smart I'm replying."
       	find('form.new_comment').click_button 'Submit' 
       	page.should have_content("I have an incredibly intelligent thing to say.")
       	page.should have_content("That's so smart I'm replying.")
       	page.should have_content(@user.firstname)
       	page.should have_content('Anonymous')
   end

   it "should register a reaction to a figure", :js => true do
       	find('div.figtoggle').click
	find('#figsection' + @figsection.id.to_s).click_button('Solid Science')
	page.should have_css('li.reactionlink.badge-success')
	find('#figsection' + @figsection.id.to_s).fill_in 'reaction_name', :with => 'Timey Wimey'
	find('#figsection' + @figsection.id.to_s).click_button 'Submit'
	#page.should have_content('Timey Wimey')
	fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
	#check_box 'anonymous'
       	click_button 'Submit'
       	find('li.replylink').click 
	fill_in 'comment_text', :with => "That's so smart I'm replying."
       	find('form.new_comment').click_button 'Submit' 
       	page.should have_content("I have an incredibly intelligent thing to say.")
       	page.should have_content("That's so smart I'm replying.")
       	page.should have_content(@user.firstname)
       	page.should have_content('Anonymous')
   end



   
end
