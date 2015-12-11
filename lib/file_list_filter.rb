module FileListFilter
  def self.filter(patterns, entries)
    patterns = [patterns].flatten
    entries.select do |entry|
      begin
        patterns.any?{|pat| File.fnmatch(pat.downcase, entry.downcase)}
      rescue ArgumentError => e
        puts(e, e.backtrace.first, entry) rescue nil
        false
      end
    end.compact
  end
end

