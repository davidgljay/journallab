require "spec_helper"

describe AssertionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/assertions" }.should route_to(:controller => "assertions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/assertions/new" }.should route_to(:controller => "assertions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/assertions/1" }.should route_to(:controller => "assertions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/assertions/1/edit" }.should route_to(:controller => "assertions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/assertions" }.should route_to(:controller => "assertions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/assertions/1" }.should route_to(:controller => "assertions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/assertions/1" }.should route_to(:controller => "assertions", :action => "destroy", :id => "1")
    end

  end
end
