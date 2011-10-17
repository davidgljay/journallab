require 'spec_helper'

describe FigsController do

  describe "GET 'build_sections'" do
    it "should be successful" do
      get 'build_sections'
      response.should be_success
    end
  end

end
