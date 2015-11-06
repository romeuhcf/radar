class MessageRouterWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(message_id)
    message = Message.find(message_id)

    return if message.cancelled?
    return if message.transmission_request.cancelled?

    if message.transmission_request.paused?
      self.class.perform_in(5.minutes, message.id) # TODO get a way to expire
      return
    end

    route = choose_sms_route(message)

    fail "No route found for message" unless route

    SmsProviderTransmissionWorker.perform_async(message.id, route.name)
  end

  def choose_sms_route(message)
    RouteProvider.enabled.first
  end

end

