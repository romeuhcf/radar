require 'rails_helper'

describe DestinationGenerator::CsvColumn do
  let(:transmission_request) { create(:transmission_request, parse_config: csv_parse_config, batch_file: csv) }
  subject{ described_class.new(transmission_request) }

  context "with headers at first line" do
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
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header.csv')) }

    describe "#total" do
      it { expect(subject.total).to eq 3 }
    end

    describe "#generate" do
      it do
        datas = []
        subject.generate do |dest_data|
          datas << dest_data
        end

        dest_data = datas[0]
        expect(dest_data).to be_instance_of DestinationData
        expect(dest_data.destination).to be_instance_of Destination
        expect(dest_data.destination.address).to eq '+5511960758475'
        expect(dest_data.destination).to be_persisted

        dest_data = datas[1]
        expect(dest_data).to be_instance_of DestinationData
        expect(dest_data.destination).to be_instance_of Destination
        expect(dest_data.destination.address).to eq '+5511998877665'
        expect(dest_data.destination).to be_persisted

        dest_data = datas[2]
        expect(dest_data).to be_nil
      end
    end
  end
  context "with headers and extra fields on some lines" do
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

    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_with_header_disarranged.csv')) }
    describe "#total" do
      it { expect(subject.total).to eq 5 }
    end

    it do
      datas = []
      subject.generate do |dest_data|
        datas << dest_data
      end

      dest_data = datas[0]

      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511960758475'

      dest_data = datas[1]
      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511998877665'

      dest_data = datas[2]
      expect(dest_data).to_not be_nil

      dest_data = datas[3]
      expect(dest_data).to_not be_nil

      dest_data = datas[4]
      expect(dest_data).to be_nil
    end
  end

  context "without headers and extra fields on some lines" do
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
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms_disarranged.csv')) }
    describe "#total" do
      it { expect(subject.total).to eq 4 }
    end

    it do
      datas = []
      subject.generate do |dest_data|
        datas << dest_data
      end

      dest_data = datas[0]

      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511960758475'

      dest_data = datas[1]
      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511998877665'

      dest_data = datas[2]
      expect(dest_data).to_not be_nil

      dest_data = datas[3]
      expect(dest_data).to be_nil
    end


  end
  context "without headers at first line" do
    let(:csv_parse_config) do
      create(:parse_config,{
        message_defined_at_column: true,
        headers_at_first_line: false,
        column_of_number: 'A',
        column_of_message: 'B',
        kind: 'csv',
        field_separator: ';',
      })
    end
    let(:csv) { Rack::Test::UploadedFile.new(fixture_file('simple_sms.csv')) }

    describe "#total" do
      it { expect(subject.total).to eq 3 }
    end

    it do
      datas = []
      subject.generate do |dest_data|
        datas << dest_data
      end

      dest_data = datas[0]

      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511960758475'

      dest_data = datas[1]
      expect(dest_data).to be_instance_of DestinationData
      expect(dest_data.destination).to be_instance_of Destination
      expect(dest_data.destination).to be_persisted
      expect(dest_data.destination.address).to eq '+5511998877665'

      dest_data = datas[2]
      expect(dest_data).to be_nil
    end
  end
end
