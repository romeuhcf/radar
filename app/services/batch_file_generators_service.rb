class BatchFileGeneratorsService
  attr_reader :transmission_request
  def initialize(transmission_request)
    @transmission_request = transmission_request
  end

  def destination_generator
    if transmission_request.batch_file_type == 'csv'
      DestinationGenerator::CsvColumn.new(transmission_request)
    else
      raise ArgumentError, "Unknown generator for type", transmission_request.batch_file_type
    end
  end

  def content_generator
    if transmission_request.batch_file_type == 'csv'
      if transmission_request.parse_config.message_defined_at_column?
        ContentGenerator::CsvColumn.new(transmission_request.parse_config)
      else
        ContentGenerator::MultiTemplate.new(transmission_request.parse_config)
      end
    else
      raise ArgumentError, "Unknown generator for type", transmission_request.batch_file_type
    end
  end

  def schedule_generator
    ScheduleGenerator::Hashing.new(transmission_request.parse_config)
  end
end
