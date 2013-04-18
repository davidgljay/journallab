require 'spec_helper'

describe "Signup" do

  it "should create a new user account" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'user_firstname', :with => "Andrea"
    fill_in 'user_lastname', :with => "Torres"
    fill_in 'user_email', :with => "AndreaTorres@gmail.com"
    fill_in 'user_password', :with => "dogsarethebest"
    fill_in 'user_password_confirmation', :with => "dogsarethebest"
    click_button 'Sign up'
    page.should have_content('Sign Out')
    assert !ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.last
    email.subject.include?('Confirmation').should be_true
    user = User.last
    user.email.should == 'andreatorres@gmail.com'
  end

  it "should not create a user account if there is an error" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'user_firstname', :with => "Andrea"
    fill_in 'user_lastname', :with => "Torres"
    fill_in 'user_password', :with => "dogsarethebest"
    fill_in 'user_password_confirmation', :with => "dogsarethebest"
    click_button 'Sign up'
    page.should have_content("Email is invalid")
  end

end

describe "Forgot Password" do
  it "should send a forgot password e-mail" do
  user = create(:user)
  visit root_path
  click_link 'Sign In'
  click_link 'Forgot your password?'
  fill_in 'user_email', :with => user.email
  click_button 'Send me reset password instructions'
  assert !ActionMailer::Base.deliveries.empty?
  email = ActionMailer::Base.deliveries.last
  email.subject.should include 'password'
  end

  it "should raise an error is the user does not exist" do
    visit root_path
    click_link 'Sign In'
    click_link 'Forgot your password?'
    fill_in 'user_email', :with => 'bad@email.com'
    click_button 'Send me reset password instructions'
    page.should have_content('Email not found')

  end

end

describe "Resend Confirmation" do

  it "should send a confirmation e-mail" do
    user = create(:user)
    user.confirmed_at = nil
    user.save
    visit root_path
    click_link 'Sign In'
    click_link "Didn't receive confirmation instructions?"
    fill_in 'user_email', :with => user.email
    click_button 'Resend confirmation instructions'
    assert !ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.last
    email.subject.should include 'Confirmation'
  end

  it "should raise an error is the user does not exist" do
    visit root_path
    click_link 'Sign In'
    click_link "Didn't receive confirmation instructions?"
    fill_in 'user_email', :with => 'bad@email.com'
    click_button 'Resend confirmation instructions'
    page.should have_content('Email not found')

  end

end

