module ScheduleGenerator
  class Hashing
    attr_reader :total

    def initialize(options)
      @options = options
    end

    def total=(total)
      @total = total
      @interval = available_seconds / @total
      @current = @options.get_start_time - @interval
    end

    def available_seconds
      # TODO, consider business hours and holidays
      ini = @options.get_start_time
      fin = @options.get_finish_time
      fin - ini
    end

    def generate
      @current += @interval # TODO consider business hours and holidays
    end
  end
end
