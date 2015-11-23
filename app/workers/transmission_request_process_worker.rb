class TransmissionRequestProcessWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => true, :backtrace => true # TODO separate queues

  def perform(transmission_request_id)
    transmission_request = TransmissionRequest.find(transmission_request_id)
    return if transmission_request.cancelled?

    if transmission_request.paused?
      # TODO put on a queue specific for paused items
      self.class.perform_in(5.minutes, transmission_request_id) # TODO get a way to expire
      return
    end



    generator_service     = BatchFileGeneratorsService.new(transmission_request)
    content_generator     = generator_service.content_generator
    destination_generator = generator_service.destination_generator
    schedule_generator    = generator_service.schedule_generator

    Transmissions::SendBatchService.new.process_request(transmission_request, content_generator, destination_generator, schedule_generator)
  end
end
