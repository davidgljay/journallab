require "spec_helper"

describe PapersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/papers" }.should route_to(:controller => "papers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/papers/new" }.should route_to(:controller => "papers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/papers/1" }.should route_to(:controller => "papers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/papers/1/edit" }.should route_to(:controller => "papers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/papers" }.should route_to(:controller => "papers", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/papers/1" }.should route_to(:controller => "papers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/papers/1" }.should route_to(:controller => "papers", :action => "destroy", :id => "1")
    end

  end
end
