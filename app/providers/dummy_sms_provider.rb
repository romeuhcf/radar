require 'provider_transmission_result'
require 'base_provider'

class DummySmsProvider < BaseProvider
  attr_accessor :base_url, :passwd

  def initialize(options = {})
  end

  def sendMessage(msisdn, sms_text, options={})
        return ProviderTransmissionResult::Success.new 'foo', 'bar'
  end
end
