require 'rails_helper'

require 'ops_sms_provider'

describe OpsSmsProvider do
  subject {OpsSmsProvider.new(password: ENV['OPS_PWD'] ) }

  describe "#sendMessage(msisdn, sms_text, options={})" do
    describe "number with msisdn" do
      let!(:result) { subject.sendMessage("5511960758475", "Teste ops") }
      it { expect(result).to be_instance_of ProviderTransmissionResult::Success }
      it { expect(result.uid).to match /^[0-9a-f@]{15,}$/ }
    end

    describe "number without msisdn" do
      let!(:result) { subject.sendMessage("11960758475", "Teste ops") }
      it { expect(result).to be_instance_of ProviderTransmissionResult::Success }
      it { expect(result.uid).to match /^[0-9a-f@]{15,}$/ }
    end

  end

  describe "#getStatus(uuid)" do

  end
end
