require 'rails_helper'

require 'beta_sms_provider'

describe BetaSmsProvider do
  subject {BetaSmsProvider.new({user: ENV['BETA_USER'], password: ENV['BETA_PWD']}) }

  describe "#sendMessage(msisdn, sms_text, options={})" do
    let!(:result) { subject.sendMessage("555988339844", "Boa noite") }
    it { expect(result).to be_instance_of ProviderTransmissionResult::Fail } # restricted access to given IPs
  end

  describe "#getStatus(uuid)" do

  end
end
