module ProviderTransmissionResult
  class Base
    attr_reader :extra, :raw
    def initialize(raw, extra = nil)
      @raw = raw && raw.to_s.strip
      @extra = extra
    end

    def fail?
      !success?
    end
  end

  class Success < Base
    def success?
      true
    end

    def uid
      @extra && @extra.to_s.strip
    end
  end

  class Fail < Base
    def success?
      false
    end

    def exception
      @extra
    end
  end
end


