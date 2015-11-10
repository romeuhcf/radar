module ProviderTransmissionResult
  class Success
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

  class Fail
    attr_reader :raw, :exception, :billable

    def initialize(raw, exception = nil, billable = false)
      @billable = billable
      @raw = raw && raw.to_s.strip
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


