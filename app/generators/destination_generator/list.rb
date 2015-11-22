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
        block.call DestinationData.new(destination)
      end
    end

    def find_or_create(address)
      Destination.find_by_address(address) || Destination.create!(address: address)
    end
  end
end
