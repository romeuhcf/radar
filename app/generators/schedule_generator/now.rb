module ScheduleGenerator
  class Now
    attr_writer :total
    def generate
      Time.zone.now
    end
  end
end
