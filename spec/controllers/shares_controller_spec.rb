require 'spec_helper'

describe SharesController do

  describe "create" do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @paper = create(:paper)
      @paper.buildout([3,3,4,5])
      @group = create(:group)
      @group.add(@user1)
      @group.add(@user2)
      @group.add(@user3)
      @group.add(@user4)
      @group2 = create(:group)
      @group2.add(@user1)
      @group2.add(@user2)
      @group2.add(@user3)
      @group2.add(@user4)
      @fig = @paper.figs.first
      @figsection = @fig.figsections.first
      sign_in @user1
    end

    it "should share the paper" do
  	lambda do
      		get 'create', :share => {:type => 'Paper', :id => @paper.id.to_s, :text => 'Check this out!!'}, :groups => {@group.id.to_s => '1', @group2.id.to_s => '0'}
	end.should change(Share.all.count,:size).by(1)
      @share = Share.last
      @share.should_not be_nil
      @share.paper.should == @paper
      @share.user.should == @user1
      @share.group.should == @group
      @group2.shares.include?(@share).should be_false
    end

   it "should share across multiple groups" do
	get 'create', :share => {:type => 'Paper', :id => @paper.id, :groups => {@group.id.to_s => '1', @group2.id.to_s => '1'}, :text => 'Check this out!!'}
      @group.shares.include?(@share).should be_true
      @group2.shares.include?(@share).should be_true
    end


    #it "should e-mail the group" do
    #  lambda do
    #     get 'create', :share => {:type => 'Paper', :id => @paper.id, :group => @group.id, :text => 'Check this out!!'}
    #  end.should change(ActionMailer::Base.deliveries,:size).by(4) 
    # @mailed_users = Maillog.all.map{|m| m.user}
    # @mailed_users.should include @user1
    # @mailed_users.should include @user2
    # @mailed_users.should include @user3
    # @mailed_users.should include @user4
    #end
  end

end
