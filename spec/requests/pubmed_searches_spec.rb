require 'spec_helper'

describe "Pubmed Searches:" do

#Sign in first
  before(:each) do
     @user = Factory(:user, :email => Factory.next(:email))
     visit '/signin'
     fill_in "session_email", :with => @user.email
     fill_in "session_password", :with => @user.password
     click_button "Sign in"
  end         



  describe "entering a pubmed id on the homepage" do
    it "loads the page for that paper" do
      visit root_path
      fill_in "pubmed_id", :with => "123456"
      click_button "Search"
      within('body') { page.should have_content('Summary') }
      within('tr.summary') { page.should have_content('Core Conclusion') }
    end
  end

  describe "inputting a core assertion" do
    it "adds an assertion to the paper" do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button "Search"
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "assertion_method", :with => "Aloe juice"
      click_button "Submit"
      within('body') { page.should have_content('Assertion was successfully') }
      within('tr.summary') { page.should have_content('Core Conclusion') }
      within('body') { page.should have_content('Lorem ipsum cupcakes.') }
      within('li.improvelink') { page.should have_content('Improve') }
    end
  end

end
