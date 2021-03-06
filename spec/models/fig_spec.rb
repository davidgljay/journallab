require 'spec_helper'

describe Fig do

   before(:each) do
     @paper = create(:paper)
     @paper.save
     @paper.buildout([3,3,2,1])
     @fig = @paper.figs.first
   end

   it "should give a short name" do
     @fig.shortname.should include "Fig " + @fig.num.to_s
   end

   it "should give a long name" do
     @fig.longname.should include "Fig " + @fig.num.to_s + " of " + @paper.title
   end

end
