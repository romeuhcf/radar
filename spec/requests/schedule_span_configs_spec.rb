require 'rails_helper'

RSpec.describe "ScheduleSpanConfigs", type: :request do
  describe "GET /schedule_span_configs" do
    it "works! (now write some real specs)" do
      get schedule_span_configs_path
      expect(response).to have_http_status(200)
    end
  end
end
