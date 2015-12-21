require 'rails_helper'

describe TransmissionRequestCompositionService do
  let(:user) { create(:user) }
  let(:csv_options) do
    create(:parse_config, {
      message_defined_at_column: true,
      headers_at_first_line: false,
      column_of_number: 'A',
      column_of_message: 'B',
      kind: 'csv',
      timing_table: 'business_hours',
      field_separator: ';',
      schedule_start_time: '2010-01-01 10:00:00',
      schedule_finish_time: '2010-01-01 11:00:00',
    })
  end
  let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms.csv')) }
  let(:transmission_request) {create(:transmission_request, parse_config: csv_options, batch_file: csv, owner: user, user: user)}
  subject{ described_class.new(transmission_request) }
  describe "#confirm" do
    it {Sidekiq::Testing.fake! { expect{subject.confirm}.to change{TransmissionRequestProcessWorker.jobs.size}.by(1)  } }
  end
end
