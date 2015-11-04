require 'generators'
class Transmissions::InlineSmsRequestService
  def create(inline_sms_request, user)
    destination_generator = DestinationGenerator::List.new(inline_sms_request.parsed_phone_list)
    content_generator = ContentGenerator::Static.new(inline_sms_request.message)
    schedule_generator = ScheduleGenerator::Now.new
    Transmissions::SendBatchService.new.generate_request("inline", content_generator, destination_generator, schedule_generator, user, user)
  end
end


