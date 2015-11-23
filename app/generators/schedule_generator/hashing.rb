module ScheduleGenerator
  class Hashing
    attr_reader :total

    def initialize(options)
      @options = options
    end

    def total=(total)
      @total = total
      @interval = available_seconds / @total
      @current = @options.schedule_start_time.to_time - @interval
    end

    def available_seconds
      # TODO, consider business hours and holidays
      ini = @options.schedule_start_time.to_time
      fin = @options.schedule_finish_time.to_time
      fin - ini
    end

    def generate
      @current += @interval # TODO consider business hours and holidays
    end
  end
end
