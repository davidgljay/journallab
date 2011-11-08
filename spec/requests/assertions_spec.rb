require 'spec_helper'

describe "Assertions" do
   before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @group = Factory(:group)
     @group.add(@user)
     @paper.buildout([3,3,2,1])
     visit '/signin'
     fill_in "session_email", :with => @user.email
     fill_in "session_password", :with => @user.password
     click_button "Sign in"
   end

  describe "inputting a core assertion for the paper" do
    it "adds an assertion to the paper", :js => true do
      visit '/papers/' + @paper.id.to_s
      click_button "Summarize for your lab"
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "assertion_method", :with => "Aloe juice"
      click_button "Submit"
     # within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr.summary') { page.should have_content('Core Conclusion') }
      within('body') { page.should have_content('Lorem ipsum cupcakes.') }
     # within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered", :js => true do
      visit '/papers/' + @paper.id.to_s
      click_button "Summarize for your lab"
      click_button "Submit"
      find('form.enter_assertion').click_button "Summarize for your lab"
    #  within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end
     
  describe "inputting a core assertion for the figure" do
    it "adds an assertion to the figure", :js => true do
      visit '/papers/' + @paper.id.to_s
      find('#fig1').click_button "Summarize for your lab"
      find('#fig1').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#fig1').fill_in 'assertion_method', :with => "Aloe juice"
      find('#fig1').click_button "Submit"
     # within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#fig1') { page.should have_content('Lorem ipsum cupcakes.') }
     # within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered", :js => true do
      visit '/papers/' + @paper.id.to_s
      find('#fig1').click_button "Summarize for your lab"
      find('#fig1').click_button "Submit"
     # within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end 
 
  describe "inputting a core assertion for the section" do
    it "adds an assertion to the section", :js => true do
      visit '/papers/' + @paper.id.to_s
      find('div.figtoggle').click
      find('#figsection1').click_button "Summarize for your lab"
      find('#figsection1').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#figsection1').fill_in 'assertion_method', :with => "Aloe juice"
      find('#figsection1').click_button "Submit"
      #within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#figsection1') { page.should have_content('Lorem ipsum cupcakes.') }
      #within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered", :js => true do
      visit '/papers/' + @paper.id.to_s
      find('div.figtoggle').click
      find('#figsection1').click_button "Summarize for your lab"
      find('#figsection1').click_button "Submit"
     # within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end 

  describe "improving an assertion" do
     before(:each) do 
     @user2 = Factory(:user, :email => Factory.next(:email))
     @user2.save  
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
     end
  
    it "works for a paper" do
      visit '/papers/' + @paper.id.to_s
      click_button "Summarize for your lab"
      find('tr#paper').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('tr#paper').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('tr#paper').find('#new_assertion').click_button "Submit"
     # within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#paper') { page.should have_content('Lorem ipsum cupcakes.') }
      within('tr#paper') { page.should have_content('Test') }
      #within('li.improvelink') { page.should have_content('Improve') }
    end

    it "works for a figure" do
      visit '/papers/' + @paper.id.to_s
      find('tr#fig1').click_button "Summarize for your lab"
      find('tr#fig1').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('tr#fig1').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('tr#fig1').find('#new_assertion').click_button "Submit"
      #within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#fig1') { page.should have_content('Lorem ipsum cupcakes.') }
      #within('li.improvelink') { page.should have_content('Improve') }
    end


    it "works for a figsection" do
      visit '/papers/' + @paper.id.to_s
      find('div.figtoggle').click
      find('tr#figsection1').click_button "Summarize for your lab"
      find('tr#figsection1').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('tr#figsection1').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('tr#figsection1').find('#new_assertion').click_button "Submit"
      within('tr#figsection1') { page.should have_content('Lorem ipsum cupcakes.') }
     # within('li.improvelink') { page.should have_content('Improve') }
    end
   end
end
