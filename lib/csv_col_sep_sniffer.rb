class CsvColSepSniffer
  NoColumnSeparatorFound = Class.new(StandardError)
  EmptyFile = Class.new(StandardError)

  COMMON_DELIMITERS = [
    '","',
    '"|"',
    '";"'
  ].freeze

  def initialize(path:)
    @path = path
  end

  def self.find(path)
    new(path: path).find
  end

  def find
    fail EmptyFile unless first

    if valid?
      delimiters[0][0][1]
    else
      fail NoColumnSeparatorFound
    end
  end

  private

  def valid?
    !delimiters.collect(&:last).reduce(:+).zero?
  end

  # delimiters #=> [["\"|\"", 54], ["\",\"", 0], ["\";\"", 0]]
  # delimiters[0] #=> ["\";\"", 54]
  # delimiters[0][0] #=> "\",\""
  # delimiters[0][0][1] #=> ";"
  def delimiters
    @delimiters ||= COMMON_DELIMITERS.inject({}, &count).sort(&most_found)
  end

  def most_found
    ->(a, b) { b[1] <=> a[1] }
  end

  def count
    ->(hash, delimiter) { hash[delimiter] = first.count(delimiter); hash }
  end

  def first
    @first ||= file.first
  end

  def file
    @file ||= File.open(@path)
  end
end
