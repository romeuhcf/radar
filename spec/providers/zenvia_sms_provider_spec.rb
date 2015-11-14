require 'rails_helper'

require 'ops_sms_provider'

describe ZenviaSmsProvider do
  subject {ZenviaSmsProvider.new(user: ENV['ZENVIA_USER'], password: ENV['ZENVIA_PWD'] ) }

  describe "#sendMessage(msisdn, sms_text, options={})" do
    describe "number with msisdn " do
      let(:uuid) { 'd67ed253-9513-411f-94ae-8c2d5e02eaaa'}

      let!(:result) do
        expect(SecureRandom).to receive(:uuid){ uuid }
        subject.sendMessage("5511960758475", "Teste integracao zenvia spec")
      end

      it { expect(result).to be_instance_of ProviderTransmissionResult::Success }
      it { expect(result.uid).to eq uuid }
    end

    describe "number without msisdn " do
      let(:uuid) { 'd67ed253-9513-411f-94ae-8c2d5e02ebbb'}

      let!(:result) do
        expect(SecureRandom).to receive(:uuid){ uuid }
        subject.sendMessage("11960758475", "Teste integracao zenvia spec")
      end

      it { expect(result).to be_instance_of ProviderTransmissionResult::Success }
      it { expect(result.uid).to eq uuid }
    end

  end

  describe "#getStatus(uuid)" do

  end

  let(:status_callback) do
    {
      "id"=>"d67ed253-9513-411f-94ae-8c2d5e02eacf",
      "status"=>"120",
      "to"=>"5511960758475",
      "msg"=>"Teste integracao zenvia spec",
    }
  end

  let(:legacy_mo_callback) do
    {"zenvia_id"=>"68447726", "received_at"=>"2015-11-13 15:12:53", "msisdn"=>"552178699349", "message"=>"So consigo pagar dia 19/11", "provider"=>"zenvia_mo"}
  end

  describe 'callback' do
    describe "#::interpret_callback" do
      describe "status callback" do
        let!(:result) { described_class.interpret_callback(status_callback) }
        it { expect(result).to be_instance_of(ProviderTransmissionResult::Success) }
        it { expect(result.uid).to eq "d67ed253-9513-411f-94ae-8c2d5e02eacf" }
        #      it { expect(result.is_final).to be_truthy }
        it { expect(result).to be_billable }
        #      it { expect(result.is_success).to be_truthy }
        it { expect(result.raw).to eq '120' }
      end

      describe "legacy mo callback" do
        let!(:result) { described_class.interpret_callback(legacy_mo_callback) }
        it { expect(result).to be_instance_of(MobileOriginatedMessage) }
      end
    end
  end

  describe "::my_callback?" do
    it {expect(described_class.my_callback?(status_callback)).to be_truthy }
    it {expect(described_class.my_callback?(status_callback.merge( { 'provider' => 'zenvia' } ))).to be_truthy }
    it {expect(described_class.my_callback?(legacy_mo_callback)).to be_truthy }
  end
end
