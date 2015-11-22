class DestinationData
  attr_reader :destination, :data
  def initialize(destination, data = nil)
    @destination = destination
    @data = data
  end
end
