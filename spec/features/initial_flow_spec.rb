require 'spec_helper'

describe "Initial Flow:" do

  before (:each) do
    Analysis.new.recent_discussions
  end
  describe 'the homepage' do


    it "should cycle through the slideshow and create a new account", :js => true do

      visit root_path
      page.should have_css('#homepage')
      page.should have_css('#discussionCarousel')
      click_link('About')
      page.should have_css('#about')
      click_link('How It Works')
      page.should have_css('#howtoCarousel')
      fill_in 'user[firstname]', :with => 'Sock'
      fill_in 'user[lastname]', :with => 'Monster'
      fill_in 'user[email]', :with => 'sockmonster@journallab.edu'
      fill_in 'user[password]', :with => 'testing'
      fill_in 'user_password_confirmation', :with => 'testing'
      click_button ('Get Started')
      User.find_by_firstname('Sock').should_not be_nil
      page.should have_css('#welcome_feed')
    end
  end

end

