require "net/http"
require "uri"
require "rexml/document"
require 'provider_transmission_result'
require 'base_provider'

class BetaSmsProvider < BaseProvider
  attr_accessor :base_url, :user
  attr_writer :passwd

  def initialize(options = {})
    options = options.with_indifferent_access
    @base_url = options.fetch('base_url', 'http://www.betasms.com.br')
    @user = options.fetch('user')
    @passwd = options.fetch('password')
    @callback_url = options['callback_url']
  end

=begin
  def getBalance
    uri = URI.parse(base_url + '/post/status.php' )
    params = {'user'=> @user, 'passwd' => @passwd }
    uri.query = URI.encode_www_form( params )
    response = Net::HTTP.get_response(uri)
    raise( ArgumentError, response) unless response.code == '200'

    if response.body =~/^200\s+OK\s+([0-9.]+)$/
      return $1.strip.to_i
    else
      raise response.body
    end

=end

  def sendMessage(msisdn, sms_text, options={})
    #valid_options = %w[schedule_time  callback_url sender] # TODO validate
    callback_url = options.fetch('callback_url', @callback_url)

    params = options.merge({
      'user'=> @user,
      'passwd' => @passwd,
      'msisdn' => msisdn,
      'sms_text' => sms_text,
      'callback_url' => callback_url
    })

    params['callback'] = params['callback_url'] ? 1 : 0

    uri = URI.parse(base_url + '/post/index.php' )
    uri.query = URI.encode_www_form( params )

    begin
      response = Net::HTTP.get_response(uri)
      if response.body =~/^200\s+OK\s+([a-fA-F0-9-]{10,})$/
        return ProviderTransmissionResult::Success.new response.body, $1.strip
      else
        return ProviderTransmissionResult::Fail.new response.body
      end
    rescue
      return ProviderTransmissionResult::Fail.new $!.message, $!
    end
  end

  def getStatus(uuid)
    uri = URI.parse(base_url + '/post/status.php' )
    uri.query = URI.encode_www_form( :uuid => uuid )
    response = Net::HTTP.get_response(uri)
    raise( ArgumentError, response) unless response.code == '200'

    doc = REXML::Document.new(response.body)

    return doc.elements['/main/status'].text.to_i, doc.elements['/main/status_text'].text.to_s

    #TODO .elements['/main/mo'].text
    #TODO .elements['/main/mo_text'].text
  end
end
