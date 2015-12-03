require 'provider_transmission_result'
require 'base_provider'

class DummySmsProvider < BaseProvider
  attr_accessor :base_url, :passwd

  def initialize(options = nil)
    options ||= {}
    @forced_hash = options[:forced_hash]
    @forced_status = options[:forced_status]
  end

  def sendMessage(msisdn, sms_text, options={})
    hash = @forced_hash || [SecureRandom.uuid, 'DUMMY'].join('-')
    status = @forced_status || random_status

    Thread.new do
      sleep 1
      SmsCallbackService.new.perform('provider' => 'dummy', 'hash' => hash, 'status' => status)
    end
    return ProviderTransmissionResult::Success.new 'dummy-received', hash
  end

  def self.my_callback?(params)
    return true if params['provider'] == 'dummy'
  end

  def self.interpret_callback(params)
    if params['status'] == 'sent'
      ProviderTransmissionResult::Success.new  params['status'], params['hash']
    else
      ProviderTransmissionResult::Fail.new raw_status, params['hash'], is_billable
    end
  end

  protected
  def random_status
    %w{sent sent sent failed}.shuffle.first
  end
end
