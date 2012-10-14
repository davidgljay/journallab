require 'spec_helper'

describe "/signin" do

	it "should render the login page" do
		visit "/users/sign_in"
		within('body') { page.should have_content('Sign in') }
	end
	
	it "should render the forgot password page" do
		visit "/users/password/new"
		within('body') { page.should have_content('Sign in') }
	end

	it "should render the email confirmation page" do
		visit "/users/confirmation/new"
		within('body') { page.should have_content('Sign in') }
	end
	
end
