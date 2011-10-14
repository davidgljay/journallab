require 'spec_helper'

describe "Assertions" do
   before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @user = Factory(:user, :email => Factory.next(:email))
     @paper.build_figs(3)
     @paper.figs.first.build_figsections(3)
     visit '/signin'
     fill_in "session_email", :with => @user.email
     fill_in "session_password", :with => @user.password
     click_button "Sign in"
   end

  describe "inputting a core assertion for the paper" do
    it "adds an assertion to the paper" do
      visit '/papers/' + @paper.id.to_s
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "assertion_method", :with => "Aloe juice"
      click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr.summary') { page.should have_content('Core Conclusion') }
      within('body') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered" do
      visit '/papers/' + @paper.id.to_s
      click_button "Submit"
      within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end
     
  describe "inputting a core assertion for the figure" do
    it "adds an assertion to the paper" do
      visit '/papers/' + @paper.id.to_s
      find('#fig1').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#fig1').fill_in 'assertion_method', :with => "Aloe juice"
      find('#fig1').click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#fig1') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered" do
      visit '/papers/' + @paper.id.to_s
      find('#fig1').click_button "Submit"
      within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end 
 
  describe "inputting a core assertion for the section" do
    it "adds an assertion to the paper" do
      visit '/papers/' + @paper.id.to_s
      find('#section1').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#section1').fill_in 'assertion_method', :with => "Aloe juice"
      find('#section1').click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('tr#section1') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end

    it "fails if nothing is entered" do
      visit '/papers/' + @paper.id.to_s
      find('#section1').click_button "Submit"
      within('body') { page.should have_content('Please enter a conclusion and method') }
    end

  end 

  describe "improving an assertion" do
     before(:each) do 
       a = []
       a << @paper.assertions.build(:text => "Test", :method => "Test method")
       a << @paper.figs.first.assertions.build(:text => "Test", :method => "Test method")
       a << @paper.figs.first.figsections.first.assertions.build(:text => "Test", :method => "Test method")
       a.each do |a|
         a.user = @user
         a.is_public = true
         a.save
       end
     end

    it "works for a paper" do
      visit '/papers/' + @paper.id.to_s
      find('#paper').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#paper').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('#paper').find('#new_assertion').click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('#paper') { page.should have_content('Lorem ipsum cupcakes.') }
      within('#paper') { page.should have_content('Test') }
      within('li.improvelink') { page.should have_content('Improve') }
    end

    it "works for a figure" do
      visit '/papers/' + @paper.id.to_s
      find('#fig1').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#fig1').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('#fig1').find('#new_assertion').click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('#fig1') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end


    it "works for a paper" do
      visit '/papers/' + @paper.id.to_s
      find('#section1').find('#new_assertion').fill_in 'assertion_text', :with => "Lorem ipsum cupcakes."
      find('#section1').find('#new_assertion').fill_in 'assertion_method', :with => "Aloe juice"
      find('#section1').find('#new_assertion').click_button "Submit"
      within('body') { page.should have_content('Summary entered, thanks for your contribution.') }
      within('#section1') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end
   end
end
