require 'spec_helper'
DatabaseCleaner.strategy = :deletion

describe "Reactions" do
  before(:each) do
    Analysis.new.recent_discussions
    @user = create(:user)
    @paper = create(:paper)
    @group = create(:group)
    @paper.lookup_info
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

  if false #Disabling quickform. If you're seeing this and don't remember what that is, feel free to delete this code.
    it "should register a reaction through the quickform", :js => true do
      find('.quickform').click_button('Solid Science')
      page.should have_css('li.reactionlink.badge-success')
      find('.quickform').fill_in 'name', :with => 'Timey Wimey'
      find('.quickform').click_button 'Submit'
      #page.should have_content('Timey Wimey')
      find('#paper' + @paper.id.to_s).fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
      #click_box 'anonymous'
      find('#paper' + @paper.id.to_s).click_button 'Submit'
      sleep(1)
      find('#paper' + @paper.id.to_s).find('li.replylink').click
      find('#paper' + @paper.id.to_s).fill_in 'comment_text', :with => "That's so smart I'm replying."
      find('#paper' + @paper.id.to_s).find('form.new_comment').click_button 'Submit'
      page.should have_content("I have an incredibly intelligent thing to say.")
      page.should have_content("That's so smart I'm replying.")
      page.should have_content(@user.firstname)
      #page.should have_content('Anonymous')
    end
  end


  it "should register a reaction to a paper", :js => true do
    first('#paper' + @paper.id.to_s).first('li.leave_reaction').click
    first('#paper' + @paper.id.to_s).first('td.sumright').click_button('Solid Science')
    page.should have_css('li.reactionlink.badge-success')
    first('#paper' + @paper.id.to_s).first('li.leave_reaction').click
    first('#paper' + @paper.id.to_s).first('li.custom_reaction').fill_in 'reaction_name', :with => 'Timey Wimey'
    first('#paper' + @paper.id.to_s).first('li.custom_reaction').click_button 'Submit'
    #page.should have_content('Timey Wimey')
    sleep(2)
    first('#paper' + @paper.id.to_s).fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
    first('#paper' + @paper.id.to_s).first('#new_comment').click_button 'Submit'
    sleep(2)
    first('#paper' + @paper.id.to_s).first('li.replylink').click
    first('#paper' + @paper.id.to_s).find('.replyform').fill_in 'comment_text', :with => "That's so smart I'm replying."
    first('#paper' + @paper.id.to_s).find('.replyform').click_button 'Submit'
    page.should have_content("I have an incredibly intelligent thing to say.")
    page.should have_content("That's so smart I'm replying.")
    page.should have_content(@user.firstname)
    #page.should have_content('Anonymous')
  end

  it "should register a reaction to a figure", :js => true do
    first('#fig' + @fig.id.to_s).first('li.leave_reaction').click
    first('#fig' + @fig.id.to_s).first('td.sumright').click_button('Solid Science')
    page.should have_css('li.reactionlink.badge-success')
    first('#fig' + @fig.id.to_s).first('li.leave_reaction').click
    first('#fig' + @fig.id.to_s).first('li.custom_reaction').fill_in 'reaction_name', :with => 'Timey Wimey'
    first('#fig' + @fig.id.to_s).first('li.custom_reaction').click_button 'Submit'
    #page.should have_content('Timey Wimey')
    sleep(2)
    first('#fig' + @fig.id.to_s).fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
    #check_box 'anonymous'
    first('#fig' + @fig.id.to_s).first('#new_comment').click_button 'Submit'
    sleep(2)
    find('li.replylink').click
    first('#fig' + @fig.id.to_s).find('.replyform').fill_in 'comment_text', :with => "That's so smart I'm replying."
    first('#fig' + @fig.id.to_s).find('.replyform').click_button 'Submit'
    page.should have_content("I have an incredibly intelligent thing to say.")
    page.should have_content("That's so smart I'm replying.")
    page.should have_content(@user.firstname)
    #page.should have_content('Anonymous')
  end

  it "should register a reaction to a figure section", :js => true do
    first('div.figtoggle').click
    first('#figsection' + @figsection.id.to_s).first('li.leave_reaction').click
    first('#figsection' + @figsection.id.to_s).click_button('Solid Science')
    page.should have_css('li.reactionlink.badge-success')
    first('#figsection' + @figsection.id.to_s).first('li.leave_reaction').click
    first('#figsection' + @figsection.id.to_s).fill_in 'reaction_name', :with => 'Timey Wimey'
    first('#figsection' + @figsection.id.to_s).find('li.custom_reaction').click_button 'Submit'
    sleep(2)
    #page.should have_content('Timey Wimey')
    first('#figsection' + @figsection.id.to_s).fill_in 'comment_text', :with => "I have an incredibly intelligent thing to say."
    #check_box 'anonymous'
    first('#figsection' + @figsection.id.to_s).first('#new_comment').click_button 'Submit'
    sleep(2)
    first('#figsection' + @figsection.id.to_s).find('li.replylink').click
    first('#figsection' + @figsection.id.to_s).find('.replyform').fill_in 'comment_text', :with => "That's so smart I'm replying."
    first('#figsection' + @figsection.id.to_s).find('.replyform').click_button 'Submit'
    page.should have_content("I have an incredibly intelligent thing to say.")
    page.should have_content("That's so smart I'm replying.")
    page.should have_content(@user.firstname)
    #page.should have_content('Anonymous')
  end




end
