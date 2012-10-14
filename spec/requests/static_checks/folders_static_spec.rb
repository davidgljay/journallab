require 'spec_helper'

describe "/folders" do

  describe "when not logged in" do

	it "should render the login page" do
		visit "/folders"
		within('body') { page.should have_content('Sign in') }
	end
  end

  describe "when logged in" do

	before :each do 
		@user = create(:user)
		integration_sign_in(@user)
	end

	it "should show a blank folders page" do
		visit '/folders'
		page.should have_content('To Read')
	end
	
	it "should show a folders page with papers in it" do 		
		@paper1 = create(:paper)
		@paper2 = create(:paper)
		@folder = @user.folders.first
		@note1 = @folder.notes.create(:about => @paper1, :user => @user)
		@note2 = @folder.notes.create(:about => @paper2, :user => @user) 
		visit '/folders'
		page.should have_content(@paper2.title)
	end

  end

end
