require 'spec_helper'

describe "Core Use Cases:" do

#Sign in first
  before(:each) do
     @user = Factory(:user)
     visit '/signin'
     fill_in "session_email", :with => @user.email
     fill_in "session_password", :with => @user.password
     click_button
  end         

  describe "entering a pubmed id on the homepage" do
    it "loads the page for that paper" do
      visit root_path
      fill_in "pubmed_id", :with => "123456"
      click_button
      response.should be_success
      response.should have_selector('h3', :content => "Summary")
      response.should have_selector('style', :content => "Core Assertion")
    end
  end

  describe "inputting a core assertion" do
    it "adds an assertion to the paper" do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
      response.should be_success
      response.should have_selector('h3', :content => "Summary")
      response.should have_selector('style', :content => "Core Assertion")
      response.should have_selector('td', :content => "Lorem ipsum cupcakes.")
      response.should have_selector('a', :content => "Improve")
    end
  end

  describe "improving an assertion" do
     before(:each) do
      visit root_path
      fill_in "pubmed_id", :with => '765767'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
     end

     it "renders an improve assertion page." do
       click_link "Improve"
       response.should be_success
       # Test for the form
       response.should have_selector('input', :id => "assertion_text", :value => "What is the core assertion of this paper?")
       # Test for the old assertion
       response.should have_selector('td', :content => "Lorem ipsum cupcakes.")
     end

    it "returns to the paper if you enter a new assertion." do
      click_link "Improve"
      fill_in "assertion_text", :with => "Lorem ipsum ice cream."
      click_button
      response.should be_success
      response.should have_selector('h3', :content => "Summary")
      response.should have_selector('style', :content => "Core Assertion")
      response.should have_selector('td', :content => "Lorem ipsum ice cream.")
      response.should have_selector('a', :content => "Improve")
    end
   end
  describe "adding a comment" do
     before(:each) do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
     end
     
     it "goes to the view comment page" do
       click_link "View Discussion"
       response.should be_success
       response.should have_selector('label', :content => "Leave a comment")
     end

     it "shows comments once they are entered" do
      click_link "View Discussion"
      fill_in "comment_text", :with => "Lorem ipsum tortilla soup."
      click_button
      response.should have_selector('span', :content => @user.name)
      response.should have_selector('div', :content => "Lorem ipsum tortilla soup.")
     end
  end
  describe "adding a question" do
     before(:each) do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
     end
     
     it "goes to the view discussion page" do
       click_link "View Discussion"
       response.should be_success
       response.should have_selector('label', :content => "Pose a question")
     end

     it "shows questions once they are entered" do
      click_link "View Discussion"
      fill_in "question_text", :with => "Lorem ipsum tortilla soup?"
      click_button "question_submit"
      response.should have_selector('span', :content => @user.name)
      response.should have_selector('div', :content => "Lorem ipsum tortilla soup?")
     end
  end

  describe "commenting on a question" do
    before(:each) do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
      click_link "View Discussion"
      fill_in "question_text", :with => "Lorem ipsum tortilla soup?"
      click_button "question_submit"
      click_link "Comment"
     end

    it "should render an entry form" do
       response.should be_success
       response.should have_selector('label', :content => "Leave a comment")
    end

    it "should show the comment once it is entered" do
      fill_in "comment_text", :with => "Lorem ipsum burritos!"
      click_button "comment_submit"
      response.should have_selector('div', :content => "Lorem ipsum burritos!")
    end
   end

  describe "answering a question" do
    before(:each) do
      visit root_path
      fill_in "pubmed_id", :with => '765987'
      click_button
      fill_in "assertion_text", :with => "Lorem ipsum cupcakes."
      fill_in "numfigs", :with => "3"
      click_button
      click_link "View Discussion"
      fill_in "question_text", :with => "Lorem ipsum tortilla soup?"
      click_button "question_submit"
      click_link "Answer"
     end

    it "should render an entry form" do
       response.should be_success
       response.should have_selector('label', :content => "Provide an answer")
    end

    it "should show the comment once it is entered" do
      fill_in "question_text", :with => "Lorem ipsum pizza!"
      click_button "question_submit"
      response.should have_selector('div', :content => "Lorem ipsum pizza!")
    end
   end

end
