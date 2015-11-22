class Transmissions::SendBatchService
  def generate_request(identification, user, owner, content_generator, destination_generator, schedule_generator)
    TransmissionRequest.create!(user: user, owner: owner, identification: identification).tap do |transmission_request|
      process_request(transmission_request, content_generator, destination_generator, schedule_generator)
    end
  end

  def process_request(transmission_request, content_generator, destination_generator, schedule_generator)
    total = destination_generator.total
    schedule_generator.total = total

    destination_generator.generate do |destination_data|
      scheduled_to = schedule_generator.generate
      content      = content_generator.generate(destination_data)
      enqueue_a_message(transmission_request.id, content, destination_data.destination, transmission_request.owner, scheduled_to)
    end
  end

  def enqueue_a_message(transmission_request_id, content, destination, owner, scheduled_to = Time.zone.now)
    attributes = {
      message_content: MessageContent.new(content: content),
      scheduled_to: scheduled_to,
      transmission_request_id: transmission_request_id,
      destination: destination,
      owner: owner
    }
    Message.create!(attributes).enqueue_transmission
  end
end
