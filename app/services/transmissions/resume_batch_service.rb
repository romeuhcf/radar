class Transmissions::ResumeBatchService
  def resume_transmission_request(transmission_request)
    transmission_request.resume!
  rescue AASM::InvalidTransition
    false
  end
end
