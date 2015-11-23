module ContentGenerator
  class CsvColumn
    def initialize(csv_options)
      @options = csv_options
    end

    def generate(destination_data)
      destination_data.data.fetch(message_column)
    end

    def message_column
      @options.column_of_message
    end
  end
end
