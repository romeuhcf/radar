require "rails_helper"

RSpec.describe FtpConfigurationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ftp_configurations").to route_to("ftp_configurations#index")
    end

    it "routes to #new" do
      expect(:get => "/ftp_configurations/new").to route_to("ftp_configurations#new")
    end

    it "routes to #show" do
      expect(:get => "/ftp_configurations/1").to route_to("ftp_configurations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ftp_configurations/1/edit").to route_to("ftp_configurations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ftp_configurations").to route_to("ftp_configurations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ftp_configurations/1").to route_to("ftp_configurations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ftp_configurations/1").to route_to("ftp_configurations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ftp_configurations/1").to route_to("ftp_configurations#destroy", :id => "1")
    end

  end
end
