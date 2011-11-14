require 'spec_helper'

describe Group do
  
  describe "A class" do
   before(:each) do
     @class = Factory(:group)
     @class.category = "class"
     @instructor = Factory(:user)
     @student1 = Factory(:user, :email => Factory.next(:email))     
     @student2 = Factory(:user, :email => Factory.next(:email))
     @outsider = Factory(:user, :email => Factory.next(:email))
     @class.make_lead(@instructor)
     @class.add(@student1)
     @class.add(@student2)     
   end

   describe "assertions" do
     before(:each) do
       @paper = Factory(:paper)
       @paper.buildout([3,3,2,1])
       @class.make_private(@paper)
       @assertion = @paper.assertions.build(:text => 'So smart!', :method => 'Big brains')
       @assertion.user = @student1
       @assertion.save
       @class.make_group(@assertion)
     end
   
   it "should be visible to an instructor" do
        @class.let_through_filter?(@assertion, @instructor).should be_true
        @assertion.is_public.should be_false
        @instructor.lead_of?(@class).should be_true
        @class.category.should == "class"
   end

   it "should be visible to the student" do
        @class.let_through_filter?(@assertion, @student1).should be_true
        @assertion.user.should == @student1
   end

   it "should be invisible to another student" do
       @assertion.user != @student2
       @student2.lead_of?(@class)
       @class.let_through_filter?(@assertion, @student2).should be_false
   end

   it "should be invisible to an outsider" do
       @class.let_through_filter?(@assertion, @outsider).should be_false
   end

   it "should be visible to another student once the paper is switched to group" do
       @class.make_group(@paper)
       @class.let_through_filter?(@assertion, @student2).should be_true
   end
  end

   describe "comments" do
     before(:each) do
       @paper = Factory(:paper)
       @paper.buildout([3,3,2,1])
       @class.make_private(@paper)
       @assertion = @paper.assertions.build(:text => 'So smart!', :method => 'Big brains')
       @assertion.user = @student1
       @assertion.save
       @class.make_group(@assertion)
       @comment = @assertion.comments.build(:text => 'Big big brains!', :form => 'comment')
       @comment.paper = @paper
       @comment.user = @student1
       @comment.save
       @class.make_group(@comment) 
     end
    it "should be visible to someone from the class" do
        @class.let_through_filter?(@comment, @student1).should be_true
        @class.let_through_filter?(@comment, @student2).should be_true
    end

    it "should not be visible to someone outside of the class" do
       @class.let_through_filter?(@comment, @outsider).should be_false
    end 
   end
 end

 describe "A lab" do
  before(:each) do
     @lab = Factory(:group)
     @rat1 = Factory(:user)     
     @rat2 = Factory(:user, :email => Factory.next(:email))
     @outsider = Factory(:user, :email => Factory.next(:email))
     @lab.add(@rat1)
     @lab.add(@rat2)     
   end

   describe "assertions" do
     before(:each) do
       @paper = Factory(:paper)
       @paper.buildout([3,3,2,1])
       @assertion = @paper.assertions.build(:text => 'So smart!', :method => 'Big brains')
       @assertion.user = @rat1
       @assertion.save
       @lab.make_public(@assertion)
     end

     it "should be visible to the people in the lab" do
       @lab.let_through_filter?(@assertion, @rat1).should be_true
       @lab.let_through_filter?(@assertion, @rat2).should be_true
     end

     it "should be visible to people outside of the lab" do
       @lab.let_through_filter?(@assertion, @outsider).should be_true
     end
   end

   describe "comments" do
     before(:each) do
       @paper = Factory(:paper)
       @paper.buildout([3,3,2,1])
       @assertion = @paper.assertions.build(:text => 'So smart!', :method => 'Big brains')
       @assertion.user = @rat1
       @assertion.save
       @lab.make_public(@assertion)
       @comment = Factory(:comment, :paper => @paper, :assertion => @assertion, :user => @rat1)
       @lab.make_group(@comment)
     end

     it "should be visible to the people in the lab" do
       @lab.let_through_filter?(@comment, @rat1).should be_true
       @lab.let_through_filter?(@comment, @rat2).should be_true
     end

     it "should be invisible to people outside of the lab" do
       @lab.let_through_filter?(@comment, @outsider).should be_false
     end
   end
  end
end
