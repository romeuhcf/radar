module DestinationGenerator
  class List
    def initialize(*list)
      @list = Array(list).flatten
    end

    def total
      @list.size
    end

    def generate(n_to_generate = nil, &block)
      @list.each_with_index do |address, n_generated|
        return if n_to_generate and n_generated >= n_to_generate
        destination = Destination.find_or_new(address)
        if destination.valid?
          destination.save!
          block.call DestinationData.new(destination)
        end
      end
    end

  end
end
