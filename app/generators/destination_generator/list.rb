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
        destination = Destination.find_or_create(address)
        block.call DestinationData.new(destination)
      end
    end

  end
end
