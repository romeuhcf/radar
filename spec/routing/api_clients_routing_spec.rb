require "rails_helper"

RSpec.describe ApiClientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api_clients").to route_to("api_clients#index")
    end

    it "routes to #new" do
      expect(:get => "/api_clients/new").to route_to("api_clients#new")
    end

    it "routes to #show" do
      expect(:get => "/api_clients/1").to route_to("api_clients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api_clients/1/edit").to route_to("api_clients#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api_clients").to route_to("api_clients#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api_clients/1").to route_to("api_clients#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api_clients/1").to route_to("api_clients#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api_clients/1").to route_to("api_clients#destroy", :id => "1")
    end

  end
end
