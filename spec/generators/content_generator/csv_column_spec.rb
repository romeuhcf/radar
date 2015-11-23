require 'rails_helper'
describe ContentGenerator::CsvColumn do
  let(:transmission_request) { create(:transmission_request, options: csv_options, batch_file: csv) }
  subject{ described_class.new(transmission_request.options) }

  context "with headers at first line" do
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
    let(:csv_options) do
      {
        message_defined_at_column: true,
        headers_at_first_line: true,
        column_of_number: 'numero',
        column_of_message: 'mensagem',
        file_type: 'csv',
        timing_table: 'business_hours',
        field_separator: ';',
        schedule_start_time: '2010-01-01 10:00:00',
        schedule_finish_time: '2010-01-01 11:00:00',
      }
    end
    let(:destination_data) { DestinationData.new('foo', {'numero' => '11960758475' , 'mensagem' => 'Mensagem de teste 1'})}

    describe "#generate(destination_data)" do
      it {expect(subject.generate(destination_data)).to eq "Mensagem de teste 1"}
    end
  end


  context "without headers at first line" do
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
    let(:csv_options) do
      {
        message_defined_at_column: true,
        headers_at_first_line: false,
        column_of_number: 'A',
        column_of_message: 'B',
        file_type: 'csv',
        timing_table: 'business_hours',
        field_separator: ';',
        schedule_start_time: '2010-01-01 10:00:00',
        schedule_finish_time: '2010-01-01 11:00:00',
      }
    end
    let(:destination_data) { DestinationData.new('foo', {'A' => '11960758475' , 'B' => 'Mensagem de teste 1'})}

    describe "#generate(destination_data)" do
      it {expect(subject.generate(destination_data)).to eq "Mensagem de teste 1"}
    end
  end
end
