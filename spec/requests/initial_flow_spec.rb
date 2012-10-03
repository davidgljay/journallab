require 'spec_helper'

describe "Initial Flow:" do


  describe "Finding feeds and registering" do
	it "lets you create feeds and then register" do
		visit root_path
		fill_in "temp_follows", :with => "lions,tigers,bears"
		click_button "Go"
		fill_in "user_firstname", :with => "Stampi"
		fill_in "user_lastname", :with => "the Dinosaur"
		fill_in "user_email", :with => "stampi@rocks.edu"
		fill_in "user_password", :with => "sampling"
		fill_in "user_password_confirmation", :with => "sampling"
		click_button "Sign up"
		page.should have_content('Sign Out')
	end
	
	it "sends back an error if no temp follows are entered" do
		visit root_path
		click_button "Go"
		page.should have_content('Enter a few of your research interests to get started.')
	end
	
	it "directs to the proper page if registration information is incomplete" do
		visit root_path
		fill_in "temp_follows", :with => "lions,tigers,bears"
		click_button "Go"
		fill_in "user_firstname", :with => "Stampi"
		fill_in "user_lastname", :with => "the Dinosaur"
		fill_in "user_email", :with => "stampi@rocks.edu"
		fill_in "user_password", :with => "sampling"
		click_button "Sign up"
		page.should have_content("Password doesn't match confirmation")

	end
	
	it "redirects to the homepage is 'welcome' is called directly" do
		visit '/welcome'
		page.should have_content('Sign In')
	end
  end
  
end

