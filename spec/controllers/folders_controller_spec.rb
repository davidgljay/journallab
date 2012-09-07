require 'spec_helper'

describe FoldersController do
before_filter :authenticate_user!

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

end
