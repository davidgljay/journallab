require 'spec_helper'

describe "papers/show" do


  describe "without any figs" do
    before :each do
      #Prep the selection dropdown for selection the # of figs in the paper.
      @numfig_select = Array.new
      30.times do |i|
        @numfig_select << [(i+1).to_s, i+1 ]
      end

      @paper = create(:paper)
      @user = create(:user)
      assign(:paper, @paper)
      assign(:heatmap, @paper.heatmap)
      assign(:heatmap_overview, @paper.heatmap_overview)
      assign(:reaction_map, @paper.reaction_map)
      assign(:numvisits, @paper.visits.map{|v| v.user}.uniq.count)
      assign(:numfig_select, @numfig_select)
      assign(:mode, 1)
      assign(:interest, 1)
    end

    it "should load when not signed in" do
      render
      assert_select "h1", :text => @paper.title
    end

    it "should load when signed in" do
      test_sign_in(@user)
      render
      assert_select "h1", :text => @paper.title
    end
  end
end
