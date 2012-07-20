require 'spec_helper'

describe "Paper not logged in:" do

   before(:each) do
     @user = Factory(:user)
     @paper = Factory(:paper)
     @paper.authors << Factory(:author)
     @paper.buildout([3,3,2,1])
     @user2 = Factory(:user, :email => Factory.next(:email))
     @group = Factory(:group)
     @group.add(@user)
     @group.add(@user2)  
     a = @paper.assertions.build(:text => "Test", :method => "Test test")
     a.is_public = true
     a.user = @user
     a.save
     @fig = @paper.figs.first
     @figsection = @fig.figsections.first
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
    visit '/papers/' + @paper.id.to_s

    end

    it "should load a paper" do
       	page.should have_content(@paper.title)
    end

end

