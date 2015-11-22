module DestinationGenerator
  class CsvColumn
    def initialize(transmission_request)
      @transmission_request = transmission_request
    end

    def total
      @total ||= TransmissionRequestCompositionService.new.estimate_number_of_messages(@transmission_request)
    end

    def generate
      yield DestinationData.new(Destination.new , {})
    end
  end
end
