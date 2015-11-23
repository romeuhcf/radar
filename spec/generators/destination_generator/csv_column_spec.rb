require 'rails_helper'

describe DestinationGenerator::CsvColumn do
  let(:transmission_request) { create(:transmission_request, options: csv_options, batch_file: csv) }
  subject{ described_class.new(transmission_request) }

  context "with headers at first line" do
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

  context "without headers at first line" do
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
