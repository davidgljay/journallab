require 'spec_helper'

describe "Signup" do

  it "should create a new user account" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'user_firstname', :with => "Andrea"
    fill_in 'user_lastname', :with => "Torres"
    fill_in 'user_email', :with => "andreatorres@gmail.com"
    fill_in 'user_password', :with => "dogsarethebest"
    fill_in 'user_password_confirmation', :with => "dogsarethebest"
    click_button 'Sign up'
    page.should have_content('Sign Out')
    assert !ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.last
    email.subject.include?('Confirmation').should be_true
  end

  it "should not create a user account if there is an error" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'user_firstname', :with => "Andrea"
    fill_in 'user_lastname', :with => "Torres"
    fill_in 'user_password', :with => "dogsarethebest"
    fill_in 'user_password_confirmation', :with => "dogsarethebest"
    click_button 'Sign up'
    page.should have_content('Email is blank')
  end



end
