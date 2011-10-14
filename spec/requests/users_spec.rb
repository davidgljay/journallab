require 'spec_helper'

describe "Users" do
  #describe "GET /users" do
  #  it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #    get users_index_path
  #    response.status.should be(200) 
  #  end
  #end

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "First Name",    :with => ""
          fill_in "Last Name",     :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button 'Sign up'
          within('div#error_explanation') { page.should have_content('Password') }

        end
      end
     end
    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "First Name",    :with => "Example"
          fill_in "Last Name",     :with => "User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button 'Sign up'
          within('div.flash.success') { page.should have_content('Welcome') }
        end
      end
     end
    end
end
