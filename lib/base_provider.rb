class BaseProvider
  def   getBalance
    fail 'abstract method'
  end

  def   sendMessage(destinationm, content, options)
    fail 'abstract method'
  end

  def getStatus(identification)
    fail 'abstract method'
  end

  def my_callback?(params)
    false
  end

  def parseCallbackStatus(params)
    fail 'abstract method'
  end
end


