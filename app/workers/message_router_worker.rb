class MessageRouterWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(message_id)
    message = Message.find(message_id)

    return if message.cancelled?
    return if message.transmission_request.cancelled?

    if message.transmission_request.paused?
      # TODO put on a queue specific for paused items
      self.class.perform_in(5.minutes, message.id) # TODO get a way to expire
      return
    end

    route = choose_sms_route(message)

    fail "No route found for message" unless route

    SmsProviderTransmissionWorker.perform_async(message.id, route.name)
    queue = ['message', 'owner', message.owner_id, 'route', route.name].join('-')
    Sidekiq::Cliente.enqueue_to(queue, SmsProviderTransmissionWorker, message_id, route.name)
  end

  def choose_sms_route(message)
    RouteProvider.enabled.first
  end
  def transfer_to_paused_queue(id)
    queue ='paused-messages'
    Sidekiq::Client.enqueue_to_in(queue, 5.minutes, self, id)
  end

end

