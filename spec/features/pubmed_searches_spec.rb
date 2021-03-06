require 'spec_helper'
DatabaseCleaner.strategy = :deletion

describe "Searches:" do

#Sign in first
  before(:each) do
    Analysis.new.recent_discussions
     @user = create(:user)
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
  end         



  describe "entering a pubmed id on the homepage" do
    it "loads the page for that paper" do
      visit root_path
      fill_in "search", :with => "21228906"
      click_button 'Search'
      within('body') { page.should have_selector('.icon-download') }
    end
  end

  describe "entering text into the homepage" do
    it "loads search results" do
     visit root_path
     fill_in "search", :with => "zombies"
     click_button 'Search'
     within('body') { page.should have_content('Search Results') }
     page.should have_content('zombies')
   end
  end

end
