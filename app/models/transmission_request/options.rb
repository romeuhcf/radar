class TransmissionRequest < ActiveRecord::Base

  class Options
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :file_type
    attr_accessor :timing_table, :custom_message
    attr_accessor :field_separator
    attr_reader :schedule_start_time, :schedule_finish_time  # date

    def schedule_start_time
      @schedule_start_time ||= Time.now
    end

    def schedule_finish_time
      @schedule_finish_time ||= Time.now + 30.minutes
    end

    def schedule_start_time=(time)
      @schedule_start_time = to_datetime(time)
    end

    def schedule_finish_time=(time)
      @schedule_finish_time = to_datetime(time)
    end

    def headers_at_first_line=(v)
      @headers_at_first_line = (v == '0' or !v) ? false : true
    end


    def merge(other)
      self.class.new(serializable_hash.merge(other))
    end

    def attributes
      {
        'file_type' => nil,
        'timing_table' => nil,
        'custom_message' => nil,
        'schedule_start_time' => nil,
        'schedule_finish_time' => nil,
      }
    end

    protected
    def to_datetime(time)
      case time
      when String
        DateTime.parse(time) # TODO parse format
      else
        time
      end
    end
  end
end
