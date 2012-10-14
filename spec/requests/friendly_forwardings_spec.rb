require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = create(:user)
    visit edit_user_path(user)
    # The test automatically follows the redirect to the signin page.
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button "Sign in"
    # The test follows the redirect again, this time to users/edit.
    have_xpath("//title", :text => "Edit")

  end
end
