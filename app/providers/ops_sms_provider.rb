require "net/http"
require "uri"
require "rexml/document"
require 'provider_transmission_result'
require 'base_provider'

class OpsSmsProvider < BaseProvider
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

      response = basic_send(params)

      code, uuid= *response.body.split(';')

      if code == '-1'
        return ProviderTransmissionResult::Success.new response.body, uuid
      else
        return ProviderTransmissionResult::Fail.new response.body
      end

    rescue
      return ProviderTransmissionResult::Fail.new $!.message, $!
    end
  end

  def remove_country_prefix(num)
    if num =~ /\A55[0-9]{10,11}\z/
      num.gsub(/^55/, '')
    else
      num
    end
  end

  def basic_send(params, method = :get)
    get_trace( @send_url, {params: params}, 120, method)
  end

  def get_trace(url, headers = nil, timeout=-1, method = :get)
    #trace('HTTP', [url,headers.to_json].join(' with ')) do
    RestClient::Request.execute(:method => method, :url => url, :headers => headers, :timeout => timeout)
    #end
  end
end
