require 'rails_helper'

RSpec.describe "FtpConfigurations", type: :request do
  describe "GET /ftp_configurations" do
    it "works! (now write some real specs)" do
      get ftp_configurations_path
      expect(response).to have_http_status(200)
    end
  end
end
