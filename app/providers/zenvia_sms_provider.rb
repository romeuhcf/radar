require 'provider_transmission_result'
require 'base_provider'

SmsTransmissionStatus = Struct.new(:uid, :is_final, :is_success, :is_billable, :raw_status, :moment)

class ZenviaSmsProvider < BaseProvider
  attr_accessor :base_url, :password, :user

  def initialize(options = {})
    options = options.with_indifferent_access
    @base_url = options.fetch('base_url', 'http://www.zenvia360.com.br/GatewayIntegration/msgSms.do')
    @user     = options.fetch('user')
    @password = options.fetch('password')
  end

  def sendMessage(msisdn, sms_text, options={})
    uuid = SecureRandom.uuid
    params = {
      account: @user,
      code: @password,
      dispatch: 'send',
      from: '',
      to: msisdn,
      msg: sms_text[0,150], # TODO check if cannot be bigger message
      id: uuid,
      callbackOption: 2
    }

    response = basic_send(@base_url, params, :post)
    code = response.split(' - ').first

    if code == '000'
      return ProviderTransmissionResult::Success.new response, uuid
    else
      return ProviderTransmissionResult::Fail.new response.body
    end

  rescue
    return ProviderTransmissionResult::Fail.new $!.message, $!
  end


  def self.my_callback?(params)
    return true if  params['provider'] == 'zenvia'

    params.keys.sort == %w{id status to msg }.sort or params.keys.sort == %w{id status to msg mobileOperatorName}.sort
  end

  def self.is_blocked_status?(status)
    %w{130 131 141}.include?(status)
  end

  def self.is_success_status?(status)
    status.to_i > 100 and status.to_i <= 171 and !is_blocked_status?(status)
  end

  def self.interpret_callback(params)
    raw_status  = params.fetch('status').to_s
    uid         = params.fetch('id')
    is_billable = !is_blocked_status?(raw_status)
    is_final    = raw_status != '100'
    is_success  = is_success_status?(raw_status)
    SmsTransmissionStatus.new(uid, is_final, is_success, is_billable, raw_status, Time.zone.now)
  end
end
