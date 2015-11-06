class SmsProviderTransmissionWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(message_id, route_name)
    message = Message.find(message_id)

    return if message.cancelled?
    return if message.transmission_request.cancelled?
    if message.transmission_request.paused?
      MessageRouterWorker.perform_in(5.minutes, message.id)
      return
    end

    route = RouteProvider.enabled.find_by(name: route_name)
    provider = route.provider
    result = provider.sendMessage(message.destination.address, message.body)
    message.set_transmission_result(result, route)
  end
end
