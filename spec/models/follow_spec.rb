require 'spec_helper'

describe Follow do

  describe "Temp Follows" do
    it "should create temp follows from a string" do
      temp_follows = "test, mrna, judson"
      follows = Follow.new.create_temp(temp_follows)
      follows.count.should == 3
      follows.first.class.should == Follow
    end
  end

  describe "Newcount" do
    before :each do
      @user = create(:user)
      @follow = @user.follows.create(:name => 'zombies', :search_term => 'zombies')
    end

    it "should return the number of recent papers in the feed if there are fewer than 40" do
      @follow.update_feed
      @follow.newcount.should == @follow.feed.count
    end

    it "should return a higher number from pubmed if there are 40 new papers in the feed" do
      @follow.name = "rna"
      @follow.search_term = "rna"
      @follow.update_feed
      @follow.newcount.should > 1000
    end

    it "should return fewer papers from pubmed if there is a recent visit." do
      @follow.name = "rna"
      @follow.search_term = "rna"
      @visit = @follow.visits.new
      @visit.user = @user
      @visit.created_at = Time.now - 1.week
      @visit.save
      @follow.update_feed
      @follow.newcount.should < 1000
    end

    it "should return fewer papers from pubmed if there is a recent visit." do
      @follow.name = "rna"
      @follow.search_term = "rna"
      @visit = @follow.visits.new
      @visit.user = @user
      @visit.created_at = Time.now - 1.day
      @visit.save
      @follow.update_feed
      @follow.newcount.should < 40
    end
  end

  describe "activity count" do

    before :each do
      @user = create(:user)
      @follow = @user.follows.create(:name => 'zombies', :search_term => 'zombies')
    end

    it "should return 0 when there are no comments and no visits." do
      @follow.recent_activity.count.should == 0
    end

    it "should return 0 when there are no new comments since the last visit." do
      @visit = @follow.visits.create(:user => @user, :visit_type => 'feed')
      @visit.created_at = Time.now - 1.week
      @visit.save
      @follow.recent_activity.count.should == 0
    end

    it "should return greater than zero when there are new comments since the last visit." do
      @visit = @follow.visits.new(:user => @user, :visit_type => 'feed')
      @visit.created_at = Time.now - 1.week
      @visit.save
      @paper = Paper.find_or_create_by_pubmed_id(@follow.feed.first[:pubmed_id])
      @attr = {:text => "zombies zombies zombies", :form => "comment", :reply_to => nil, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      @comment = @paper.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @follow.recent_activity.count.should == 1
    end

    it "should return greater than zero when there are comments and no visits." do
      @paper = Paper.find_or_create_by_pubmed_id(@follow.feed.first[:pubmed_id])
      @attr = {:text => "zombies zombies zombies", :form => "comment", :reply_to => nil, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      @comment = @paper.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @follow.recent_activity.count.should == 1
    end

    it "should return greater than zero when there are comments which mention the key term on papers which do not." do
      @paper = create(:paper)
      @attr = {:text => "zombies zombies zombies", :form => "comment", :reply_to => nil, :owner_id => @paper.id, :owner_type => @paper.class.to_s}
      @comment = @paper.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @follow.recent_activity.count.should == 1
    end
  end

  describe "comments_feed" do
    before :each do
      @user = create(:user)
      @follow = @user.follows.create(:name => 'zombies', :search_term => 'zombies')
      @attr = {:text => "zombies zombies zombies", :form => "comment"}
    end

    it "should return a papers with a comments" do
      @paper = create(:paper)
      @comment = @paper.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @follow.comments_feed.count.should == 1
    end

    it "should return only papers with comment" do
      @paper1 = create(:paper)
      @paper2 = create(:paper)
      @comment = @paper1.comments.new(@attr)
      @comment.user = @user
      @comment.save
      @follow.comments_feed.count.should == 1
    end

  end
end
