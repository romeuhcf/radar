module DestinationGenerator
  class List
    def initialize(*list)
      @list = Array(list).flatten
    end

    def total
      @list.size
    end
    def generate(&block)
      @list.each do |address|
        destination = find_or_create(address)
        block.call destination
      end
    end

    def find_or_create(address)
      Destination.find_by(address: address) || Destination.create!(address: address)
    end
  end
end

module ContentGenerator
  class Static
    def initialize(value)
      @value = value
    end

    def generate(destination)
      @value
    end
  end
end

module ScheduleGenerator
  class Now
    def generate
      Time.zone.now
    end

    def total=(total)
      @total = total
    end
  end
end


