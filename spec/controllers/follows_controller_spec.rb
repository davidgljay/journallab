require 'spec_helper'

describe FollowsController do

  describe "Viewswitch" do
    before(:each) do
      @user = create(:user)
      @follow = @user.follows.create(:name => 'zombies', :search_term => 'zombies')
      @paper1 = Paper.find_or_create_by_pubmed_id(@follow.feed[0][:pubmed_id])
      @paper1.title = 'Zombies love brains'
      @paper1.save
      @paper2 = Paper.find_or_create_by_pubmed_id(@follow.feed[1][:pubmed_id])
      @paper2.title = 'The Walking Dead'
      @paper2.save
      @attr = {:text => "zombies zombies zombies", :form => "comment"}
      @comment = @paper1.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @comment.feedify
    end

    it "should switch to view only papers with comments" do
      get 'viewswitch', :switchto => 'comments', :follow => @follow.id
      assigns(:feed).nil?.should == false
      assigns(:feed).map{|p| p[:pubmed_id]}.should include @paper1.pubmed_id
      assigns(:feed).map{|p| p[:pubmed_id]}.should_not include @paper2.pubmed_id
    end

    it "should switch to view all papers" do
      get 'viewswitch', :switchto => 'all', :follow => @follow.id
      assigns(:feed).map{|p| p[:pubmed_id]}.should include @paper1.pubmed_id
      assigns(:feed).map{|p| p[:pubmed_id]}.should include @paper2.pubmed_id
    end

  end



end
