module PrinomeFilter
  def prinome(input)
    palavra(input, 1)
  end

  def palavra(input, n = 1)
    input.to_s.strip.split(/\s+/)[n-1]
  end
end

class LiquidTemplateService
  def initialize(source)
    self.source = source
  end

  def source=(source)
    @source = source
    @template = Liquid::Template.parse(@source) #, :error_mode => :strict)
  end

  def render(data)
    data.stringify_keys!
    @template.render(data, filters: filters)
  end

  def filters
    [PrinomeFilter]
  end

  def warnings
    @template.warnings
  end
end


