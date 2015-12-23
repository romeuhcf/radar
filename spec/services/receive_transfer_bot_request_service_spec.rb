require 'rails_helper'


describe ReceiveTransferBotRequestService do
  let(:transfer_bot) { create(:transfer_bot) }
  let!(:provider) { create(:route_provider) }

  it do
    Sidekiq::Testing.inline! do
      transmission_request = subject.receive(fixture_file('simple_sms.csv'), 'beautiful_name.csv', transfer_bot)
      expect(transmission_request).to be_persisted
      transmission_request.reload
      expect(transmission_request.status).to eq 'finished'
      expect(transmission_request.requested_via).to eq 'ftp'
      expect(transmission_request.identification).to eq 'beautiful_name.csv'
      expect(transmission_request.owner).to eq transfer_bot.owner
      expect(transmission_request.batch_file_type).to eq 'csv'
      expect(File.basename(transmission_request.batch_file.current_path)).to eq 'beautiful_name.csv'
      expect(transmission_request.messages.count).to eq 2
    end
  end
end
