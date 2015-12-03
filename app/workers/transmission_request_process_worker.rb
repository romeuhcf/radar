class TransmissionRequestProcessWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(transmission_request_id, pause_check = false)
    transmission_request = TransmissionRequest.find(transmission_request_id)
    return if transmission_request.cancelled?
    return transfer_to_paused_queue(transmission_request_id) if pause_check && transmission_request.paused?

    generator_service     = BatchFileGeneratorsService.new(transmission_request)
    content_generator     = generator_service.content_generator
    destination_generator = generator_service.destination_generator
    schedule_generator    = generator_service.schedule_generator

    Transmissions::SendBatchService.new.process_request(transmission_request, content_generator, destination_generator, schedule_generator)
  end

  def transfer_to_paused_queue(transmission_request_id)
    queue ='paused-transmission-requests'
    Sidekiq::Client.enqueue_to_in(queue, 5.minutes, self.class, transmission_request_id)
  end
end
