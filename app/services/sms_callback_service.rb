class SmsCallbackService
  def perform(params)
    the_provider = BaseProvider.providers.find{|provider| provider.my_callback?(params) }
    request  = the_provider.interpret_callback(params)

    if request.is_a? ProviderTransmissionResult
      # TODO: make this a service
      the_message = Localizer.get_item(request.uid)
      the_message.update_transmission_result(request)
    elsif request.is_a? MobileOriginatedMessage
      ChatRoomService.new.receive_mobile_originated_message(request)
    else
      fail "Unexpected callback type '#{request.class}' callback: #{params.to_json}" # provavelmente ocorrera qdo nao tivermos os dados certos num callback
    end
  end
end
