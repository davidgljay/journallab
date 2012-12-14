require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
     describe "when not signed in" do
    
      it "should be successful" do
	get 'home'
        response.should be_success
        response.body.should have_selector('title', :content => "Home")
      end
     end     

    end

		

  describe "GET 'about'" do
    it "should be successful" do
       get 'about'
       response.should be_success
       response.body.should have_selector('title', :content => "About")
     end
   end
    

end
