require 'spec_helper'
DatabaseCleaner.strategy = :deletion

describe "Assertions" do
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
   end

  describe "inputting a core assertion" do
     before(:each) do
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
      visit '/papers/' + @paper.id.to_s
     end

  describe "for the paper" do
    it "adds an assertion to the paper", :js => true do
	first('#paper' + @paper.id.to_s).first('.latest_assertion').click
  sleep(1)
	first('#paper' + @paper.id.to_s).first("#assertion_text").set("Stampisaur")
	first('#paper' + @paper.id.to_s).first("#new_assertion").click_button("Submit")
  within('#paper' + @paper.id.to_s + '.summary') { page.should have_text("Stampisaur") }
end

#    it "processes a summary request", :js => true do
#	first('#paper' + @paper.id.to_s).first('form#new_sumreq').click
#	within('#paper' + @paper.id.to_s) { page.should have_content('Got it!') }
#    end

    it "fails if nothing is entered", :js => true do
	first('#paper' + @paper.id.to_s).first('.latest_assertion').click
	first('#paper' + @paper.id.to_s).first(:button, "Submit").click
	within('#paper' + @paper.id.to_s + '.summary') { page.should have_content('Click to enter summary') }
    end

  end
     
  describe "for the figure" do
    it "adds an assertion to the figure", :js => true do
	first('#fig' + @fig.id.to_s ).first('.latest_assertion').click
  sleep(1)
	first('#fig' + @fig.id.to_s ).first("#assertion_text").set("Lorem ipsum cupcakes.")
	first('#fig' + @fig.id.to_s ).first("#new_assertion").click_button "Submit"
	first('#fig' + @fig.id.to_s ).first('p.method').click
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end

  end 
 
  describe "for the section" do
    it "adds an assertion to the section", :js => true do
	first('.figtoggle').click
	#first('#fig' + @fig.id.to_s ).first('form#new_sumreq').click
	#within('#fig' + @fig.id.to_s ) { page.should have_content('Got it!') }
	first('#figsection' + @figsection.id.to_s ).first('.latest_assertion').click
  sleep(1)
	first('#figsection' + @figsection.id.to_s ).first("#assertion_text").set("Lorem ipsum cupcakes.")
	first('#figsection' + @figsection.id.to_s ).first("#new_assertion").click_button "Submit"
	sleep(2)
	first('#figsection' + @figsection.id.to_s ).first('p.method').click
  sleep(1)
	first('#figsection' + @figsection.id.to_s ).first("#assertion_method_text").set("Aloe juice")
	first('#figsection' + @figsection.id.to_s ).first(".methods_form").click_button "Submit"
	within('tr#figsection' + @figsection.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end


  end 
  end

  describe "improving an assertion" do
     before(:each) do 
     @user2 = create(:user)
     @user2.save  
     a = @paper.assertions.build(:text => "Test", :method_text => "Test test")
     a.is_public = true
     a.user = @user
     a.save
     @paper.figs.each do |f|
       a = f.assertions.build(:text => "Test", :method_text => "Test test")
       a.is_public = true
       a.user = @user
       a.save
       f.figsections.each do |s|
          a = s.assertions.build(:text => "Test", :method_text => "Test test")
          a.is_public = true
          a.user = @user2
          a.save
       end
      end
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
      visit '/papers/' + @paper.id.to_s
     end

    it "works for a paper", :js => true do
	first('.latest_assertion').click
  sleep(1)
	first("#assertion_text").set("Lorem ipsum cupcakes.")
	first('form.edit_assertion').click_button "Submit"
	sleep(1)
	within('body') { page.should have_content('Lorem ipsum cupcakes.') }
    end


    it "works for a figure", :js => true do
	first('#fig' + @fig.id.to_s ).first('div.latest_assertion').click
  sleep(1)
	first('#fig' + @fig.id.to_s ).first("#assertion_text").set("Lorem ipsum cupcakes.")
	first('#fig' + @fig.id.to_s ).first('form.edit_assertion').click_button "Submit"
  sleep(1)
	first('#fig' + @fig.id.to_s ).first('p.method').click
	sleep(1)
	first('#fig' + @fig.id.to_s ).first("#assertion_method_text").set("Aloe juice")
	first('#fig' + @fig.id.to_s ).first(".methods_form").click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end


    it "works for a figsection", :js => true do
	first('div.figtoggle').click
	#first('#fig' + @fig.id.to_s ).first('form#new_sumreq').click
	#within('#fig' + @fig.id.to_s ) { page.should have_content('Got it!') }
	first('#fig' + @fig.id.to_s ).first('div.latest_assertion').click
  sleep(1)
	first('#fig' + @fig.id.to_s ).first("#assertion_text").set("Lorem ipsum cupcakes.")
	first('#fig' + @fig.id.to_s ).first('form.edit_assertion').click_button "Submit"
  sleep(1)
	first('#fig' + @fig.id.to_s ).first('p.method').click
  sleep(2)
	first('#fig' + @fig.id.to_s ).first("#assertion_method_text").set("Aloe juice")
	first('#fig' + @fig.id.to_s ).first(".methods_form").click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end
   end
end
