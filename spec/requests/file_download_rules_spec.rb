require 'rails_helper'

RSpec.describe "FileDownloadRules", type: :request do
  describe "GET /file_download_rules" do
    it "works! (now write some real specs)" do
      get file_download_rules_path
      expect(response).to have_http_status(200)
    end
  end
end
