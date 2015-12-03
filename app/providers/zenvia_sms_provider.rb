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
      return ProviderTransmissionResult::Fail.new response.body, nil
    end
  rescue
    return ProviderTransmissionResult::Fail.new $!.message, nil, $!
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

  def self.interpret_transmission_status_callback(params)
    raw_status  = params.fetch('status').to_s
    uid         = params.fetch('id')
    is_billable = !is_blocked_status?(raw_status)
    #is_final    = raw_status != '100'
    is_success  = is_success_status?(raw_status)

    if is_success
      ProviderTransmissionResult::Success.new raw_status, uid
    else
      ProviderTransmissionResult::Fail.new raw_status, uid, nil, is_billable
    end
  end

  def self.interpret_answer_callback(params)
    # XXX this is legacy, should me removed after dettaching from legacy and be replaced by lista_respostas
    msisdn    = params.fetch('msisdn')
    content   = params.fetch('message')
    sent_time = params['received_at'] && parse_date(params['received_at'])

    MobileOriginatedMessage.new(msisdn, content, sent_time)
  end

  def self.parse_date(date)
    DateTime.strptime([date, Time.zone.now.strftime("%z") ].join(' '), "%Y-%m-%d %H:%M:%S %z")
  end
=begin
  def lista_respostas
    response = basic_send(@send_url, {account: @user , code: @password, dispatch: 'listReceived'}, :get)
    lines = response.lines.each.map(&:chomp!)
    if lines.shift == '300 - Received messages found'
      # 44174262;19/01/2015 21:06:05;5511960758475;Muita demaod.....
      lines.map do |i|
        id, date, msisdn, message = i.split(';')
        set_time =  parse_date(date)
        ChatRoomService.new.receive_message_from(content, msisdn, sent_time)
        # TODO call ChatRoomService
      end
    else
      []
    end
=end
end

