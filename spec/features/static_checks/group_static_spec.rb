require 'spec_helper'

describe "Visiting the group profile page" do
  before(:each) do
    @paper1 = create(:paper)
    @paper2 = create(:paper)
    @paper3 = create(:paper)
    @group = create(:group)
    @group.save
    @user = create(:user)
    @group.make_lead(@user)
    @user.save
    @group.reload
    @paper1.build_figs(4)
    @paper2.build_figs(3)
    @paper3.build_figs(6)
    @comment = create(:comment, :paper => nil, :fig => @paper1.figs.first)
    create(:comment, :paper => nil, :fig => @paper1.figs.first)
    create(:comment, :paper => nil, :fig => @paper2.figs.first)
    create(:comment, :paper => nil, :fig => @paper2.figs.last)
    create(:comment, :paper => nil, :fig => @paper3.figs.first)
    create(:comment, :paper => nil, :fig => @paper3.figs.first)
  end

  it "should work when a user is not logged in" do
    visit '/groups/' + @group.urlname
    page.should have_content(@group.name)
  end

  it "should work when a user logged in and not a member of the group" do
    @user2 = create(:user)
    integration_sign_in(@user2)
    visit '/groups/' + @group.urlname
    page.should have_content(@group.name)
    page.should have_content('Join')
  end

  it "should work when a user logged in and is a member of the group" do
    integration_sign_in(@user)
    visit '/groups/' + @group.urlname
    page.should have_content(@group.name)
    page.should have_content('Leave')
  end



end