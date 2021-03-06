require 'rails_helper'
describe ScheduleGenerator:: Hashing do
  let(:transmission_request) { create(:transmission_request, schedule_span_config: csv_options, batch_file: csv) }
  let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
  let(:csv_options) do
    create(:schedule_span_config,{
      time_table: 'business_hours',
      start_time: '2010-01-01 10:00:00',
      finish_time: '2010-01-01 11:00:00',
    })
  end
  subject{ described_class.new(transmission_request.schedule_span_config) }

  describe "#generate" do
    it do
      subject.total = 3600
      times = []
      subject.total.times {     times << subject.generate }
      ini_time = Time.parse('2010-01-01T10:00:00-0200')
      end_time = Time.parse('2010-01-01T11:00:00-0200')

      expect((times.first - ini_time)).to be < 10
      expect((times.last - end_time)).to be < 10
    end
  end
end
