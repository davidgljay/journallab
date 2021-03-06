require 'spec_helper'

describe AnalysisController do

  describe "GET 'dashboard'" do
    it "returns http success" do
      @user = create(:user)
      @user.admin = true
      @user.save
      @a = Analysis.new
      @a.dashboard
      test_sign_in(@user)
      get 'dashboard'
      response.should be_success
    end
  end

end
