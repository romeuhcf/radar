class ReceiveTransferBotRequestService
  def receive(file_path, original_basename, transfer_bot)
    transmission_request = TransmissionRequest.new(owner: transfer_bot.owner)
    transmission_request.batch_file_from_file(file_path, original_basename)
    transmission_request.identification = original_basename
    transmission_request.requested_via = transfer_bot.ftp_config.kind.to_s.underscore
    transmission_request.parse_config = transfer_bot.parse_config
    transmission_request.schedule_span_config = transfer_bot.schedule_span_config
    TransmissionRequestCompositionService.new(transmission_request).confirm
    transmission_request
  end
end
