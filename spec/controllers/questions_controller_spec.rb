require 'spec_helper'

describe QuestionsController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'answer'" do
    it "should be successful" do
      get 'answer'
      response.should be_success
    end
  end

end
