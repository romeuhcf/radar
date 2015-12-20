require "rails_helper"

RSpec.describe TransferBotsController, type: :routing do
  describe "routing" do

    xit "routes to #index" do
      expect(:get => "/transfer_bots").to route_to("transfer_bots#index")
    end

    xit "routes to #new" do
      expect(:get => "/transfer_bots/new").to route_to("transfer_bots#new")
    end

    xit "routes to #show" do
      expect(:get => "/transfer_bots/1").to route_to("transfer_bots#show", :id => "1")
    end

    xit "routes to #edit" do
      expect(:get => "/transfer_bots/1/edit").to route_to("transfer_bots#edit", :id => "1")
    end

    xit "routes to #create" do
      expect(:post => "/transfer_bots").to route_to("transfer_bots#create")
    end

    xit "routes to #update via PUT" do
      expect(:put => "/transfer_bots/1").to route_to("transfer_bots#update", :id => "1")
    end

    xit "routes to #update via PATCH" do
      expect(:patch => "/transfer_bots/1").to route_to("transfer_bots#update", :id => "1")
    end

    xit "routes to #destroy" do
      expect(:delete => "/transfer_bots/1").to route_to("transfer_bots#destroy", :id => "1")
    end

  end
end
