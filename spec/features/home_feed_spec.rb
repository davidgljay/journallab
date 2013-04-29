require 'spec_helper'
DatabaseCleaner.strategy = :deletion

describe "Home feeds" do

  before(:each) do
    Analysis.new.recent_discussions
     @user = create(:user)
	   @follow1 = @user.follows.create(:name => 'lions', :search_term => 'lions')
	   @follow2 = @user.follows.create(:name => 'tigers', :search_term => 'tigers')
	   @follow3 = @user.follows.create(:name => 'peanutjuice', :search_term => 'peanutjuice')
     @follow1.update_feed
     @follow2.update_feed
     @follow3.update_feed
     @user.set_feedhash
     visit '/users/sign_in'
     fill_in "user_email", :with => @user.email
     fill_in "user_password", :with => @user.password
     click_button "Sign in"
  end         

  it "should load home feeds and switch between them", :js => true do
	page.should have_content('lions')
	page.should have_content('View Abstract')
	page.should have_content('Add to Folder')
	click_button 'tigers'
    sleep(3)
	page.should have_text('tigers')
	click_button 'peanutjuice'
	sleep(3)
	page.should have_content('No search results on pubmed')
	find('.feedPlus').click
  sleep(1)
	fill_in 'follow_search_term', :with => 'bears'
	click_button 'Follow'
	click_button 'bears'
    sleep(2)
	page.should have_content 'bears'
	find('.feedPlus').click
	first('.feed_remove').click
  end
end
