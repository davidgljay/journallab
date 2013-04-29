require 'spec_helper'

describe PagesController do
  render_views

  before (:each) do
    Analysis.new.recent_discussions
  end

  describe "GET 'home'" do
     describe "when not signed in" do
    
      it "should be successful" do
	get 'home'
        response.should be_success
      end
     end     

    end

		

  describe "GET 'about'" do
    it "should be successful" do
       get 'about'
       response.should be_success
     end
   end
    

end
