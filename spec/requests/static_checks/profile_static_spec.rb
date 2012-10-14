require 'spec_helper'

describe "Static User Profile" do

	before :each do 
		@user = create(:user)
	end

  describe "when not logged in" do

	it "should render the login page" do
		visit "/users/" + @user.id.to_s
		within('body') { page.should have_content('Sign In') }
	end
  end

  describe "when logged in" do

	it "should show the user's profile" do
		integration_sign_in(@user)
		visit "/users/" + @user.id.to_s
		within('body') { page.should have_content(@user.lastname) }
	end
	
  end

end
