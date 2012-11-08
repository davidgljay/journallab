require 'spec_helper'

describe "Rendering shared/_user_info" do

  before(:each) do
    @paper = create(:paper)
    @user = create(:user)
    @user.assign_anon_name(@paper)
  end

  describe "anonymously" do

    it "should display 'Anonymous' and an anon name" do
      assign(:paper, @paper)
      render :partial => '/shared/user_info', :locals => {:user => @user, :date => Time.now, :anonymous => true}
      assert_select "div", :class => 'anon_name'
      assert_select "font", :text => @user.anon_name(@paper)
    end

    it "should display only anonymous if no or date paper are given" do
      assign(:user, @user)
      render :partial => '/shared/user_info', :locals => {:user => @user, :date => nil, :anonymous => true}
      assert_select "div", :class => 'anon_name'
    end

  end

  describe "publicly" do

    it "should display the users name" do
      assign(:paper, @paper)
      render :partial => '/shared/user_info', :locals => {:user => @user, :date => Time.now, :anonymous => false}
      assert_select "div", :class => 'user_name'
    end
  end
end

