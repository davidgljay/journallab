require 'spec_helper'

describe "Searches:" do

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

  describe "entering text into the homepage" do
    it "loads search results" do
     visit root_path
     fill_in "pubmed_id", :with => "judson"
     click_button "Search"
     within('body') { page.should have_content('Search Results') }
     click_link 'Efficacy and Safety of Apremilast in Chronic Cutaneous Sarcoidosis.'
     page.should have_content('Judson')
   end
  end

end
