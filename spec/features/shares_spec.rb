require 'spec_helper'

describe "Shares:" do
 if false # disabling until shares are re-enabled
 before(:each) do
     @user = create(:user)
     @paper = create(:paper)
     @paper.buildout([3,3,2,1])
     @user2 = create(:user)
     @group = create(:group)
     @group.add(@user)
     @group.add(@user2)  
     a = @paper.assertions.build(:text => "Test", :method => "Test test")
     a.is_public = true
     a.user = @user
     a.save
     @paper.figs.each do |f|
       a = f.assertions.build(:text => "Test", :method => "Test test")
       a.is_public = true
       a.user = @user
       a.save
       f.figsections.each do |s|
          a = s.assertions.build(:text => "Test", :method => "Test test")
          a.is_public = true
          a.user = @user2
          a.save
       end
    end      
      visit '/users/sign_in'
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "Sign in"
     visit '/papers/' + @paper.id.to_s
   end

  it "shares a paper.", :js => true do
      find('div.share_button_text').click
      fill_in 'share_text', :with => "This is the bees stripes."
      click_button 'Share'
      page.should have_content("Shared!")
      @group.reload.feed.first[:item_type].should == "Share"
  end
 end
end
