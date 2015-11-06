require 'rails_helper'
require 'provider_transmission_result'
RSpec.describe Message, type: :model do
  describe '#suspended?' do
    it{ expect(subject).to respond_to(:suspended?) }
    before do
      subject.build_transmission_request(status: 'paused')
    end

    context 'when request is paused' do
      it {expect(subject).to be_suspended }
    end
  end

  describe "transmission_result=" do
    let(:message) { create(:message) }
    let(:route_provider) { create(:route_provider) }
    let(:provider_hash) { 'balbalblabalblablabla' }
    let(:transmission_result) { ProviderTransmissionResult::Success.new("Yahoo", provider_hash) }
    before do
      message.set_transmission_result(transmission_result, route_provider)
    end

    it "adds notification" do
      expect(message.status_notifications.count).to eq 1
      expect(message.status_notifications.first.route_provider).to eq route_provider
    end

    it "sets its result" do
      expect(message).to be_sent
    end

    it "adds the localizer" do
      expect(message.localizer).to_not be_nil
      expect(message.localizer.uid).to eq provider_hash
    end
  end
end
