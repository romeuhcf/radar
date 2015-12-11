require "rails_helper"

RSpec.describe FileDownloadRulesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/file_download_rules").to route_to("file_download_rules#index")
    end

    it "routes to #new" do
      expect(:get => "/file_download_rules/new").to route_to("file_download_rules#new")
    end

    it "routes to #show" do
      expect(:get => "/file_download_rules/1").to route_to("file_download_rules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/file_download_rules/1/edit").to route_to("file_download_rules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/file_download_rules").to route_to("file_download_rules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/file_download_rules/1").to route_to("file_download_rules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/file_download_rules/1").to route_to("file_download_rules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/file_download_rules/1").to route_to("file_download_rules#destroy", :id => "1")
    end

  end
end
