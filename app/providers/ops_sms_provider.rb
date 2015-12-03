require "net/http"
require "uri"
require "rexml/document"
require 'provider_transmission_result'
require 'phone_number_utils'
require 'base_provider'

class OpsSmsProvider < BaseProvider
  include PhoneNumberUtils
  attr_accessor :base_url, :passwd

  def initialize(options = {})
    options = options.with_indifferent_access
    @send_url = options.fetch('send_url', 'http://200.155.65.83/smsmachine/envio.php')
    @status_url = options.fetch('status_url', 'http://186.226.85.40/smsmachine/relatoriosms.php')
    @passwd = options.fetch('password')
  end

  def sendMessage(msisdn, sms_text, options={})
    begin
      params =  {
        s: @passwd,
        cel: remove_country_prefix(msisdn),
        m: sms_text,
        resumido: 'sim',
        dup: 'sim'
      }

      response = basic_send(@send_url, params)

      code, uuid= *response.body.split(';')

      if code == '-1'
        return ProviderTransmissionResult::Success.new response.body, uuid
      else
        return ProviderTransmissionResult::Fail.new response.body, nil
      end

    rescue
      return ProviderTransmissionResult::Fail.new $!.message, nil, $!
    end
  end
end
