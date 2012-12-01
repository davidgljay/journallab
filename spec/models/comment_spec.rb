require 'spec_helper'

describe Comment do
  
  describe "creating" do
    it "should create a commentnotice with feedify" do
      @paper = create(:paper)
      @comment = create(:comment, :paper => @paper, :text => 'Tasty Noodle Soup')
      @user = create(:user)
      @follow = @user.follows.create(:name => 'soup', :search_term => 'soup')
      @comment.feedify
      @comment.commentnotices.count.should == 1
    end
  end

end
