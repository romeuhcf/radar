require 'provider_transmission_result'
require 'base_provider'
require 'phone_number_utils'

class ZenviaSmsProvider < BaseProvider
  include PhoneNumberUtils
  attr_accessor :base_url, :password, :user

  def initialize(options = {})
    options = options.with_indifferent_access
    @base_url = options.fetch('base_url', 'http://www.zenvia360.com.br/GatewayIntegration/msgSms.do')
    @user     = options.fetch('user')
    @password = options.fetch('password')
  end

  def sendMessage(number, sms_text, options={})
    uuid = SecureRandom.uuid
    params = {
      account: @user,
      code: @password,
      dispatch: 'send',
      from: '',
      to: with_country_code(number),
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
    return true if params['provider'] == 'zenvia'
    return true if params.keys.include?('zenvia_id')
    return true if params.keys.sort == %w{id status to msg }.sort
    return true if params.keys.sort == %w{id status to msg mobileOperatorName}.sort

    return false
  end

  def self.is_blocked_status?(status)
    %w{130 131 141}.include?(status)
  end

  def self.is_success_status?(status)
    status.to_i > 100 and status.to_i <= 171 and !is_blocked_status?(status)
  end

  def self.interpret_callback(params)
    if params.keys.include?('zenvia_id') and params.keys.include?('message')
      interpret_answer_callback(params)
    else
      interpret_transmission_status_callback(params)
    end
  end

  def interpret_transmission_status_callback(params)
    raw_status  = params.fetch('status').to_s
    uid         = params.fetch('id')
    is_billable = !is_blocked_status?(raw_status)
    #is_final    = raw_status != '100'
    is_success  = is_success_status?(raw_status)

    if is_success
      ProviderTransmissionResult::Success.new raw_status, uid
    else
      ProviderTransmissionResult::Fail.new raw_status, nil, is_billable
    end
  end

  def interpret_answer_callback(params)
    # TODO
    fail 'not implemented'
  end
end
