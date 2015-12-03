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

  describe "set_transmission_result" do
    let(:message) { create(:transmission_request).messages.first }
    let!(:route_provider) { create(:route_provider) }
    let(:provider_hash) { 'balbalblabalblablabla' }
    let(:transmission_result) { ProviderTransmissionResult::Success.new("Yahoo", provider_hash) }

    before do
      Sidekiq::Testing.fake! do
        message.set_transmission_result(transmission_result, route_provider)
      end
    end

    it "adds notification" do
      expect(message.status_notifications.count).to eq 1
      expect(message.status_notifications.first.route_provider).to eq route_provider
    end

    it "sets its billable property" do
      expect(message).to be_billable
    end

    it "sets its result" do
      expect(message).to be_sent
      expect(message.sent_at).to_not be_nil
    end

    it "adds the localizer" do
      expect(message.localizer).to_not be_nil
      expect(message.localizer.uid).to eq provider_hash
    end
  end

  describe "update_transmission_result" do
    let(:message) { create(:transmission_request).messages.first }
    let!(:route_provider) { create(:route_provider) }
    let(:provider_hash) { 'balbalblabalblablabla' }
    let(:transmission_result) { ProviderTransmissionResult::Success.new("Yahoo", provider_hash) }

    before do
      Sidekiq::Testing.fake! do
        message.set_transmission_result(transmission_result, route_provider)
        message.update_transmission_result(transmission_update)
      end
    end

    describe "success is alway sbillable" do
      let(:transmission_update) { ProviderTransmissionResult::Success.new("Hurray", provider_hash) }
      it { expect(message.status_notifications.count).to eq 2 }
      it { expect(message).to be_billable }
      it { expect(message).to be_sent }
      it { expect(message).to_not be_failed }
    end

    describe "non success and non billable" do
      let(:transmission_update) { ProviderTransmissionResult::Fail.new("Hurray", provider_hash, nil, _billable = false) }
      it { expect(message.status_notifications.count).to eq 2 }
      it { expect(message).to_not be_billable }
      it { expect(message).to_not be_sent }
      it { expect(message).to be_failed }
    end

    describe "non success but billable" do
      let(:transmission_update) { ProviderTransmissionResult::Fail.new("Hurray", provider_hash, nil, _billable = true) }
      it { expect(message.status_notifications.count).to eq 2 }
      it { expect(message).to be_billable }
      it { expect(message).to_not be_sent }
      it { expect(message).to be_failed }
    end



  end
end
