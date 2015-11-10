class SmsCallbackService
  def perform(params)
    the_provider = BaseProvider.providers.find{|provider| provider.my_callback?(params) }
    the_status   = the_provider.interpret_callback(params)
    the_message  = Localizer.get_item(the_status.uid)

    the_message.update_transmission_result(the_status)
  end
end
