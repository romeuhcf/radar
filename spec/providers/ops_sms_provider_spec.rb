require 'rails_helper'

require 'ops_sms_provider'

describe OpsSmsProvider do
  subject {OpsSmsProvider.new(password: ENV['OPS_PWD'] ) }

  describe "#sendMessage(msisdn, sms_text, options={})" do
    let!(:result) { subject.sendMessage("5511988339844", "Boa noite") }
    it { expect(result).to be_instance_of ProviderTransmissionResult::Success }
    it { expect(result.info).to match /^[0-9a-f@]{15,}$/ }
  end

  describe "#getStatus(uuid)" do

  end
end
