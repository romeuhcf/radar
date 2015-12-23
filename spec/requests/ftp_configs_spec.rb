require 'rails_helper'

RSpec.describe "FtpConfigs", type: :request do
  describe "GET /ftp_configs" do
    it "works! (now write some real specs)" do
      get ftp_configs_path
      expect(response).to have_http_status(302)
    end
  end
end
