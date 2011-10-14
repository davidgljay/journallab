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



end
