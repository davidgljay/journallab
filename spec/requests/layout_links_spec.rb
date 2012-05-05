require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
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
      within('div#utNav') { page.should have_content('Sign in') }
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in "Email",    :with => @user.email
      fill_in "Password", :with => @user.password
      click_button "Sign in"
    end

    it "should have a signout link" do
      visit root_path
      within('div#utNav') { page.should have_content('Sign out') }
    end

    it "should have a profile link" do 
      within('div#utNav') { page.should have_content('Profile') }
    end
  end
end
