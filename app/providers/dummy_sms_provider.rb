require 'provider_transmission_result'
require 'base_provider'

class DummySmsProvider < BaseProvider
  attr_accessor :base_url, :passwd
  @@sent=0
  def initialize(options = nil)
    options ||= {}
    @forced_hash = options[:forced_hash]
    @forced_status = options[:forced_status]
  end

  def sendMessage(msisdn, sms_text, options={})
    hash = @forced_hash || [SecureRandom.uuid, 'DUMMY'].join('-')
    status = @forced_status || cycle_status
    @@sent +=1
    Thread.new do
      sleep 0.3
      SmsCallbackWorker.perform_in(2.seconds, 'provider' => 'dummy', 'hash' => hash, 'status' => status, 'callback' => 'yes')
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
      ProviderTransmissionResult::Fail.new params['status'], params['hash'], false
    end
  end

  protected
  def cycle_status
    ['failed', 'sent'][@@sent % 2]
  end
end
