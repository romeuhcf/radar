class MessageRouterWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(message_id)
    message = Message.includes(:transmission_request).find(message_id)
    return if message.cancelled?
    return if message.transmission_request.cancelled?
    return transfer_to_paused_queue(message_id) if message.transmission_request.paused?

    route = choose_sms_route(message)

    fail "No route found for message" unless route

    queue = ['message', 'owner', message.owner_id, 'route', route.name].join('-')
    Sidekiq::Client.enqueue_to(queue, SmsProviderTransmissionWorker, message_id, route.name)
  end

  def choose_sms_route(message)
    RouteProvider.enabled.first
  end

  def transfer_to_paused_queue(id)
    queue ='paused-messages'
    Sidekiq::Client.enqueue_to_in(queue, 5.minutes, self.class, id)
  end

end

