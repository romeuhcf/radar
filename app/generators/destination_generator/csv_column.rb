require 'extensions/integer'
module DestinationGenerator
  class CsvColumn
    def initialize(transmission_request)
      @transmission_request = transmission_request
    end

    def total
      @total ||= @transmission_request.composer.estimate_number_of_messages
    end

    def generate(n_to_generate = nil)
      n_generated = 0
      with_csv do |csv|
        csv.each do |row|
          return if n_to_generate and n_generated >= n_to_generate
          next if row.empty?
          destination =  destination_data(row)

          if destination
            yield destination
            n_generated +=1
          end
        end
      end
    end

    def destination_data(row)
      row = to_hash(row)
      number = number_on(row)
      destination = Destination.find_or_new(number)

      if destination.valid?
        destination.save!
        DestinationData.new(destination, to_hash(row))
      else
        nil
      end
    end

    def number_on(row)
      row_column = @transmission_request.options.column_of_number
      row.fetch(row_column)
    end

    def headers(row)
      @headers ||= if @transmission_request.options.headers_at_first_line?
                     rows.first.headers
                   else
                     (1..(row.size)).to_a.map(&:to_column)
                   end
    end

    def to_hash(row)
      if @transmission_request.options.headers_at_first_line?
        row.to_hash
      else
        Hash[*headers(row).zip(row).flatten]
      end
    end

    def with_csv(&block)
      path = @transmission_request.batch_file.current_path
      open_mode = 'r'

      open_options = {
        col_sep: @transmission_request.options.field_separator,
        headers: @transmission_request.options.headers_at_first_line
      }

      CSV.open(path, open_mode, open_options) do |csv|
        yield csv
      end
    end
  end
end
