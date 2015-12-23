require 'rails_helper'
describe ContentGenerator::CsvColumn do
  let(:transmission_request) { create(:transmission_request, parse_config: csv_parse_config, batch_file: csv) }
  subject{ described_class.new(transmission_request.parse_config) }

  context "with headers at first line" do
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
    let(:csv_parse_config) do
      create :parse_config,
      {
        message_defined_at_column: true,
        headers_at_first_line: true,
        column_of_number: 'numero',
        column_of_message: 'mensagem',
        kind: 'csv',
        field_separator: ';',
      }
    end
    let(:destination_data) { DestinationData.new('foo', {'numero' => '11960758475' , 'mensagem' => 'Mensagem de teste 1'})}

    describe "#generate(destination_data)" do
      it {expect(subject.generate(destination_data)).to eq "Mensagem de teste 1"}
    end
  end


  context "without headers at first line" do
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }
    let(:csv_parse_config) do
      create :parse_config,
      {
        message_defined_at_column: true,
        headers_at_first_line: false,
        column_of_number: 'A',
        column_of_message: 'B',
        kind: 'csv',
        field_separator: ';',
      }
    end
    let(:destination_data) { DestinationData.new('foo', {'A' => '11960758475' , 'B' => 'Mensagem de teste 1'})}

    describe "#generate(destination_data)" do
      it {expect(subject.generate(destination_data)).to eq "Mensagem de teste 1"}
    end
  end
end
