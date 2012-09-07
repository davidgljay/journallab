require 'spec_helper'

describe "Searches:" do

#Sign in first
  before(:each) do
     @user = Factory(:user, :email => Factory.next(:email))
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
  end         



  describe "entering a pubmed id on the homepage" do
    it "loads the page for that paper" do
      visit root_path
      fill_in "pubmed_id", :with => "21228906"
      click_button 'GO'
      within('body') { page.should have_content('Download') }
    end
  end

  describe "entering text into the homepage" do
    it "loads search results" do
     visit root_path
     fill_in "pubmed_id", :with => "judson, robert"
     click_button 'GO'
     within('body') { page.should have_content('Search Results') }
     click_link 'Multiple targets of miR-302 and miR-372 promote reprogramming of human fibroblasts to induced pluripotent stem cells.'
     page.should have_content('Judson')
   end
  end

end
