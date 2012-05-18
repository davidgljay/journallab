require 'spec_helper'

describe "Assertions" do
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
   end

  describe "inputting a core assertion" do
     before(:each) do
	visit '/users/signin'
	fill_in "session_email", :with => @user.email
	fill_in "session_password", :with => @user.password
	click_button "Sign in"
	visit '/papers/' + @paper.id.to_s

     end

  describe "for the paper" do
    it "adds an assertion to the paper", :js => true do
	find('#paper' + @paper.id.to_s).find('p.method').click
	find('#paper' + @paper.id.to_s).fill_in "assertion_method_text", :with => "Aloe juice"
	click_button "Submit"
	find('div.latest_assertion').click
	fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	click_button "Submit"
	within('body') { page.should have_content('Lorem ipsum cupcakes.') }
end

    it "processes a summary request", :js => true do
	find('#paper' + @paper.id.to_s).find('form#new_sumreq').click
	within('#paper' + @paper.id.to_s) { page.should have_content('Got it!') }
    end

    it "fails if nothing is entered", :js => true do
	find('div.latest_assertion').click
	click_button "Submit"
	within('div.latest_assertion') { page.should have_content('Click to enter summary') }
    end

  end
     
  describe "for the figure" do
    it "adds an assertion to the figure", :js => true do
	find('#fig' + @fig.id.to_s ).find('div.latest_assertion').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	find('#fig' + @fig.id.to_s ).find('p.method').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_method_text", :with => "Aloe juice"
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end

  end 
 
  describe "for the section" do
    it "adds an assertion to the section", :js => true do
	find('div.figtoggle').click
	find('#fig' + @fig.id.to_s ).find('form#new_sumreq').click
	within('#fig' + @fig.id.to_s ) { page.should have_content('Got it!') }
	find('#fig' + @fig.id.to_s ).find('div.latest_assertion').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	find('#fig' + @fig.id.to_s ).find('p.method').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_method_text", :with => "Aloe juice"
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end


  end 
  end

  describe "improving an assertion" do
     before(:each) do 
     @user2 = Factory(:user, :email => Factory.next(:email))
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
      visit '/signin'
      fill_in "session_email", :with => @user.email
      fill_in "session_password", :with => @user.password
      click_button "Sign in"
      visit '/papers/' + @paper.id.to_s
     end

    it "works for a paper", :js => true do
	find('div.latest_assertion').click
	fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	click_button "Submit"
	find('p.method').click
	fill_in "assertion_method_text", :with => "Aloe juice"
	click_button "Submit"
	within('body') { page.should have_content('Lorem ipsum cupcakes.') }
    end


    it "works for a figure", :js => true do
	find('#fig' + @fig.id.to_s ).find('div.latest_assertion').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	find('#fig' + @fig.id.to_s ).find('p.method').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_method_text", :with => "Aloe juice"
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end


    it "works for a figsection", :js => true do
	find('div.figtoggle').click
	find('#fig' + @fig.id.to_s ).find('form#new_sumreq').click
	within('#fig' + @fig.id.to_s ) { page.should have_content('Got it!') }
	find('#fig' + @fig.id.to_s ).find('div.latest_assertion').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	find('#fig' + @fig.id.to_s ).find('p.method').click
	find('#fig' + @fig.id.to_s ).fill_in "assertion_method_text", :with => "Aloe juice"
	find('#fig' + @fig.id.to_s ).click_button "Submit"
	within('tr#fig' + @fig.id.to_s ) { page.should have_content('Lorem ipsum cupcakes.') }
    end
   end
end
