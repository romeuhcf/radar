class Transmissions::SendBatchService
  def generate_request(identification, content_generator, destination_generator, schedule_generator, user, owner)
    total                = destination_generator.total
    TransmissionRequest.create!(user: user, owner: owner, identification: identification).tap do |transmission_request|

      schedule_generator.total = total

      destination_generator.generate do |destination|
        scheduled_to = schedule_generator.generate
        content      = content_generator.generate(destination)

        generate_a_message(transmission_request.id, scheduled_to, content, destination)
        #transmission_request.progress_process!
      end
      #transmission_request.complete_process!
    end
  end

  def generate_a_message(transmission_request_id, scheduled_to, content, destination)
    attributes   = {
      message_content: MessageContent.new(content: content),
      scheduled_to: scheduled_to,
      transmission_request_id: transmission_request_id,
      destination: destination
    }
    Message.create!(attributes)
  end
end
