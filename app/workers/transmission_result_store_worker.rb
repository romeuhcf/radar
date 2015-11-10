class TransmissionResultStoreWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(message_id, serialized_result, route_id)
    result = YAML.load(serialized_result)
    message = Message.find(message_id)
    Message.transaction do
      message.set_transmission_result(result, route_id)
    end
  end
end
