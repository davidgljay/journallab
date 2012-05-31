require 'spec_helper'

describe SharesController do

  describe "create" do
    before(:each) do
      @user1 = Factory(:user, :email => Factory.next(:email))
      @user2 = Factory(:user, :email => Factory.next(:email))
      @user3 = Factory(:user, :email => Factory.next(:email))
      @user4 = Factory(:user, :email => Factory.next(:email))
      @paper = Factory(:paper)
      @paper.buildout([3,3,4,5])
      @group = Factory(:group)
      @group.add(@user1)
      @group.add(@user2)
      @group.add(@user3)
      @group.add(@user4)
      @fig = @paper.figs.first
      @figsection = @fig.figsections.first
      test_sign_in(@user1)
    end

    it "should share the paper" do
      get 'create', :share => {:type => 'Paper', :id => @paper.id, :group => @group.id, :text => 'Check this out!!;'}
      share = Share.last
      share.paper.should == @paper
      share.user.should == @user1
    end

    it "should share the figure" do
      get 'create', :share => {:type => 'Fig', :id => @fig.id, :group => @group.id, :text => 'Check this out!!;'}
      share = Share.last
      share.fig.should == @fig
      share.user.should == @user1
    end

    it "should share a figsection" do
       get 'create', :share => {:type => 'Figsection', :id => @figsection.id, :group => @group.id, :text => 'Check this out!!;'}
       share = Share.last
       share.figsection.should == @figsection
       share.user.should == @user1
    end

    it "should add to the group's feed" do
      get 'create', :share => {:type => 'Paper', :id => @paper.id, :group => @group.id, :text => 'Check this out!!;'}
      share = Share.last
      @group.reload.feed.first[:item].should == share
    end

    it "should e-mail the group" do
      lambda do
         get 'create', :share => {:type => 'Paper', :id => @paper.id, :group => @group.id, :text => 'Check this out!!'}
      end.should change(ActionMailer::Base.deliveries,:size).by(4) 
      @mailed_users = Maillog.all.map{|m| m.user}
      @mailed_users.should include @user1
      @mailed_users.should include @user2
      @mailed_users.should include @user3
      @mailed_users.should include @user4
    end
  end

end
