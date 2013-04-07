require 'spec_helper'

describe Group do

  describe "adding users" do
    it "should send an e-mail to the group lead" do
      @group = create(:group)
      @lead = create(:user)
      @newuser = create(:user)
      @group.add(@lead)
      @group.make_lead(@lead)
      @group.add(@newuser)
      Maillog.last.about.should == @group
      Maillog.last.user_id.should == @lead.id
    end

    it "should make a user a lead of the group" do
      @user = create(:user)
      @group = create(:group)
      @group.add(@user)
      @group.make_lead(@user)
      @group.reload
      @group.users.include?(@user).should be_true
      @user.save
      @user.reload
      @user.lead_of?(@group).should be_true
    end

  end

  describe "discussing papers" do
    it "should allow a group lead to add a paper to discussion" do
      @paper = create(:paper)
      @user = create(:user)
      @group = create(:group)
      @group.make_lead(@user)
      @user.save
      @user.reload
      @group.reload
      @group.discuss(@paper, @user)
      @group.save
      @group.reload
      @group.discussions.empty?.should be_false
    end
  end

  describe "saving recent discussions hash" do
    before :each do
      @paper1 = create(:paper)
      @paper2 = create(:paper)
      @group = create(:group)
      @group.save
      @user = create(:user)
      @group.make_lead(@user)
      @user.save
      @group.reload
      @paper1.build_figs(4)
      @paper2.build_figs(3)
      @comment = create(:comment, :paper => nil, :fig => @paper1.figs.first)
      create(:comment, :paper => nil, :fig => @paper1.figs.first)
      create(:comment, :paper => nil, :fig => @paper2.figs.first)
      create(:comment, :paper => nil, :fig => @paper2.figs.last)
    end

    it "should work if the group has no discussions" do
      @group.set_recent_discussions
      @group.recent_discussions.empty?.should be_true
    end

    it "should work if there are multiple discussions" do
      @user.reload
      @group.discuss(@paper1, @user)
      @group.discuss(@paper2, @user)
      @group.reload
      @group.set_recent_discussions
      @user.save
      @user.reload
      @group.recent_discussions.empty?.should be_false
      @group.recent_discussions.first[:hottest_fig_comment].should == @comment.text
      @group.recent_discussions.first[:paper_id].should == @paper1.id
      @group.recent_discussions.count.should == 1
    end
  end
end
