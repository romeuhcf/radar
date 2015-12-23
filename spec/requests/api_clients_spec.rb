require 'rails_helper'

RSpec.describe "ApiClients", type: :request do
  describe "GET /api_clients" do
    it "works! (now write some real specs)" do
      get api_clients_path
      expect(response).to have_http_status(302)
    end
  end
end
