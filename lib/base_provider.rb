class BaseProvider
  @@providers = []
  def self.inherited(subclass)
    @@providers << subclass
  end

  def self.providers
    @@providers
  end

  def getBalance
    fail 'abstract method'
  end

  def sendMessage(destinationm, content, options)
    fail 'abstract method'
  end

  def getStatus(identification)
    fail 'abstract method'
  end

  def self.my_callback?(params)
    false
  end

  def self.interpret_callback(params)
    fail 'abstract method'
  end

  def basic_send(send_url, params, method = :get)
    get_trace( send_url, {params: params}, 120, method)
  end

  def get_trace(url, headers = nil, timeout=-1, method = :get)
    #trace('HTTP', [url,headers.to_json].join(' with ')) do
    RestClient::Request.execute(:method => method, :url => url, :headers => headers, :timeout => timeout)
    #end
  end
end
