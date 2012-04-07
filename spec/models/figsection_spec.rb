require 'spec_helper'

describe Figsection do

   before(:each) do
     @paper = Factory(:paper)
     @paper.save
     @paper.buildout([3,3,2,1])
     @figsection = @paper.figs.first.figsections.first
   end

   it "should give a short name" do
     @figsection.shortname.should include "Fig " + @figsection.fig.num.to_s + @figsection.letter(@figsection.num)
   end

   it "should give a long name" do
     @figsection.longname.should include "Fig " + @figsection.fig.num.to_s + @figsection.letter(@figsection.num) + " of " + @paper.title
   end

end
