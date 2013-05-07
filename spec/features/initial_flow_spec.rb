require 'spec_helper'

describe "Initial Flow:" do

  before (:each) do
    Analysis.new.recent_discussions
    @randomizer = rand(1000)
    @group = create(:group, :public => true, :category => 'jclub', :urlname => 'group')

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
      fill_in 'user[email]', :with => 'sockmonster' + @randomizer.to_s + '@journallab.edu'
      fill_in 'user[password]', :with => 'testing'
      fill_in 'user_password_confirmation', :with => 'testing'
      click_button ('Get Started')
      sleep(2)
      @user = User.find_by_firstname('Sock')
      @user.should_not be_nil
      page.should have_css('#welcome_feed')
      fill_in 'follow[search_term]', :with => '1,2,3,4,5'
      click_button 'Track PubMed'
      Group.all.select{|g| g.public && g.category == 'jclub'}.count.should == 1
      @group.add(@user)
      visit root_path
      fill_in 'user[position]', :with => 'PhD'
      fill_in 'user[institution]', :with => 'University of Rocks'
      click_button('Update Profile')
      page.should have_css('#step3Carousel')
      create(:reaction, :user => @user)
      visit root_path
      page.should have_css('#step4Carousel')
      create(:assertion, :user => @user)
      visit root_path
      page.should have_css('#bigCarousefl')


    end
  end

end

