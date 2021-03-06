require 'spec_helper'

describe "LayoutLinks" do

  before (:each) do
    Analysis.new.recent_discussions
  end

  it "should have a Home page at '/'" do
    visit '/'
    have_xpath("//title", :text => "Home")
  end


  it "should have the right links on the layout" do
    visit root_path
    click_link "Home"
    have_xpath("//title", :text => "Home")

  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      within('div#utNav') { page.should have_content('Sign In') }
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = create(:user)
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
    end

    it "should have a signout link" do
      visit root_path
      within('div#utNav') { page.should have_content('Sign Out') }
    end

    it "should have a profile link" do 
      within('div#utNav') { page.should have_content('Profile') }
    end
  end
end
