require 'rails_helper'

RSpec.describe "ParseConfigs", type: :request do
  describe "GET /parse_configs" do
    it "works! (now write some real specs)" do
      get parse_configs_path
      expect(response).to have_http_status(302)
    end
  end
end
