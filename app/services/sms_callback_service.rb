class SmsCallbackService
  def perform(params)
    the_provider = BaseProvider.providers.find{|provider| provider.my_callback?(params) }
    result  = the_provider.interpret_callback(params)

    if result.is_a? ProviderTransmissionResult
      the_message = Localizer.get_item(result.uid)
      if the_message
        the_message.update_transmission_result(result)
      else
        Rails.logger.warn "Message callback to message not sent by me #{params.to_json}"
      end
    elsif result.is_a? MobileOriginatedMessage
      ChatRoomService.new.receive_mobile_originated_message(result)
    else
      fail "Unexpected callback type '#{result.class}' callback: #{params.to_json}" # provavelmente ocorrera qdo nao tivermos os dados certos num callback
    end
  end
end
