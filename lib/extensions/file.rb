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
end
