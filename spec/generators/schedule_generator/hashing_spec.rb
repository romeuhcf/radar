require 'rails_helper'
describe ScheduleGenerator:: Hashing do
  let(:transmission_request) { create(:transmission_request, parse_config: csv_options, batch_file: csv) }
  let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
  let(:csv_options) do
    create(:parse_config,{
      message_defined_at_column: true,
      headers_at_first_line: true,
      column_of_number: 'numero',
      column_of_message: 'mensagem',
      kind: 'csv',
      timing_table: 'business_hours',
      field_separator: ';',
      schedule_start_time: '2010-01-01 10:00:00',
      schedule_finish_time: '2010-01-01 11:00:00',
    })
  end
  subject{ described_class.new(transmission_request.parse_config) }

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
