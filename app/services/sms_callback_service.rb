class SmsCallbackService
  def perform(params)
    the_provider = BaseProvider.providers.find{|provider| provider.my_callback?(params) }
    request  = the_provider.interpret_callback(params)

    if request.is_a? ProviderTransmissionResult
      # TODO: make this a service
      the_message = Localizer.get_item(request.uid)
      if the_message
        the_message.update_transmission_result(request)
      else
        Rails.logger.warn "Message callback to message not sent by me #{params.to_json}"
      end
    elsif request.is_a? MobileOriginatedMessage
      ChatRoomService.new.receive_mobile_originated_message(request)
    else
      fail "Unexpected callback type '#{request.class}' callback: #{params.to_json}" # provavelmente ocorrera qdo nao tivermos os dados certos num callback
    end
  end
end
