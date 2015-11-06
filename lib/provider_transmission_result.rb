module ProviderTransmissionResult
  class Base
    attr_reader :info, :extra
    def initialize(info, extra = nil)
      @info = info
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
  end

  class Fail < Base
    def success?
      false
    end
  end
end


