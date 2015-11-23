require 'rails_helper'
describe TransmissionRequestProcessWorker do
  let(:transmission_request) { create(:transmission_request, size: 0, options: csv_options, batch_file: csv, status: 'scheduled') }

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

    describe "#perform(transmission_request_id)" do
      before do
        Sidekiq::Testing.fake! do
          subject.perform(transmission_request.id)
          transmission_request.reload
        end
      end

      it { expect(transmission_request.messages.size).to eq 2 }
      it { expect(transmission_request.status).to eq 'finished' }
      it { expect(transmission_request.messages.first.scheduled_to).to eq Time.parse('2010-01-01T10:00:00.000-02:00') }

      # pq na estimativa eram 3 mensagens
      it { expect(transmission_request.messages.last.scheduled_to).to eq Time.parse('2010-01-01T10:20:00.000-02:00') }

      it { expect(transmission_request.messages.first.destination.address).to eq '+5511960758475' }
      it { expect(transmission_request.messages.first.message_content.content).to eq 'Mensagem de teste 1' }
      it { expect(transmission_request.messages.last.message_content.content).to eq 'Mensagem de teste 2' }

    end
  end
end
