module ContentGenerator
  class MultiTemplate
    def initialize(options)
      @options = options
      @template = LiquidTemplateService.new(options.custom_message)
    end

    def generate(destination)
      @template.render(destination.data)
    end
  end
end
