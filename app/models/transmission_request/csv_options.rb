class TransmissionRequest

  class CsvOptions < Options
    attr_reader :message_defined_at_column, :headers_at_first_line # boolean
    attr_reader :column_of_message, :column_of_number # string
    attr_accessor :field_separator

    def message_defined_at_column=(v)
      @message_defined_at_column = (v == '0' or !v) ? false : true
    end

    def column_of_message=(v)
      @column_of_message = v && v.to_s
    end

    def column_of_number=(v)
      @column_of_number = v && v.to_s
    end

    def headers_at_first_line?
      @headers_at_first_line && true
    end

    def message_defined_at_column?
      @message_defined_at_column && true
    end

    def attributes
      super.merge(
        {
          'field_separator'  => nil,
          'message_defined_at_column' => nil,
          'headers_at_first_line' => nil,
          'column_of_message' => nil,
          'column_of_number' => nil,
        }
      )
    end
  end
end


