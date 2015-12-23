class File
  def self.head(path, n = 10)
    open(path) do |f|
      lines = []
      n.times do
        line = f.gets || break
        lines << line
      end
      lines
    end
  end

  def self.wc_l(fname)
    %x{ wc -l #{Shellwords.escape(fname)} }.strip.to_i
  end

  def force_name(forced_name)
    @forced_name = forced_name
  end

  def original_filename
    if @forced_name
      @forced_name
    else
      super
    end
  end

end
