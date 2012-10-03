require 'spec_helper'

describe "papers/show" do


  describe "without any figs" do
    before :each do
 	#Prep the selection dropdown for selection the # of figs in the paper.  
 	@numfig_select = Array.new
 	30.times do |i| 
 		@numfig_select << [(i+1).to_s, i+1 ]
 	end

 	@paper = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))	
	@paper.lookup_info
	@user = Factory(:user, :email => Factory.next(:email))
	@user.save
   end

   it "should load when not signed in" do
	visit '/papers/' + @paper.id.to_s
	within('body') { page.should have_content(@paper.title) }
   end

   it "should load when signed in" do
	integration_sign_in(@user)
	visit '/papers/' + @paper.id.to_s
	within('body') { page.should have_content(@paper.title) }
   end
  end

  describe "with figs" do
    before :each do
 	#Prep the selection dropdown for selection the # of figs in the paper.  
 	@numfig_select = Array.new
 	30.times do |i| 
 		@numfig_select << [(i+1).to_s, i+1 ]
 	end

 	@paper = Factory(:paper, :pubmed_id => Factory.next(:pubmed_id))	
	@paper.buildout([3,2,2,2])
	@paper.lookup_info
	@user = Factory(:user, :email => Factory.next(:email))
	@user.save
   end

   it "should load when not signed in" do
	visit '/papers/' + @paper.id.to_s
	within('body') { page.should have_content(@paper.title) }
   end

   it "should load when signed in" do
	integration_sign_in(@user)
	visit '/papers/' + @paper.id.to_s
	within('body') { page.should have_content(@paper.title) }
   end
  end

end

