require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
     describe "when not signed in" do
    
      before(:each) do
        get 'home'

      end
      it "should be successful" do
        response.should be_success
        response.body.should have_selector('title', :content => "Home")
      end
     end     

     pending "add homepage functionality to #{__FILE__}"

  end


  describe "GET 'about'" do
    it "should be successful" do
       get 'about'
       response.should be_success
       response.body.should have_selector('title', :content => "About")
     end
   end
    

end
