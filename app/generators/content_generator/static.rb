module ContentGenerator
  class Static
    def initialize(value)
      @value = value
    end

    def generate(_destination)
      @value
    end
  end
end
