class ProviderTransmissionResult
  class Success < ProviderTransmissionResult
    attr_reader :uid, :raw

    def initialize(raw, uid)
      @raw = raw && raw.to_s.strip
      @uid = uid && uid.to_s.strip
    end

    def success?
      true
    end

    def fail?
      !success?
    end

    def billable?
      true
    end
  end

  class Fail < ProviderTransmissionResult

    attr_reader :raw, :exception, :billable, :uid

    def initialize(raw, uid = nil, exception = nil, billable = false)
      @raw = raw && raw.to_s.strip
      @uid = uid
      @billable = billable
      @exception = exception
    end

    def success?
      false
    end

    def fail?
      !success?
    end

    def billable?
      !!@billable
    end
  end
end


