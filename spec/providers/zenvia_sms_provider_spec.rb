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

  describe 'callback' do
    let(:callback) do
      {
        "id"=>"d67ed253-9513-411f-94ae-8c2d5e02eacf",
        "status"=>"120",
        "to"=>"5511960758475",
        "msg"=>"Teste integracao zenvia spec",
      }
    end

    describe "#::interpret_callback" do
      let!(:result) { described_class.interpret_callback(callback) }
      it { expect(result).to be_instance_of(SmsTransmissionStatus) }
      it { expect(result.uid).to eq "d67ed253-9513-411f-94ae-8c2d5e02eacf" }
      it { expect(result.is_final).to be_truthy }
      it { expect(result.is_billable).to be_truthy }
      it { expect(result.is_success).to be_truthy }
      it { expect(result.raw_status).to eq '120' }
    end

    describe "::my_callback?" do
      it {expect(described_class.my_callback?(callback)).to be_truthy }
      it {expect(described_class.my_callback?(callback.merge( { 'provider' => 'zenvia' } ))).to be_truthy }
    end
  end
end
