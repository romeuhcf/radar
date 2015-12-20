from = ARGV.shift
to=ARGV.shift

require 'set'
p und_from= from.underscore
p und_to = to.underscore

def entries
  Dir['**/*']
end

contents_to_translate = [
  [from.singularize.pluralize.underscore, to.singularize.pluralize.underscore],
  [from.singularize.pluralize.underscore.camelize, to.singularize.pluralize.underscore.camelize],
  [from.singularize.underscore, to.singularize.underscore],
  [from.singularize.underscore.camelize, to.singularize.underscore.camelize],
]

files_named =Set.new
directories_named = Set.new
files_containing = Set.new


def skip?(e)
  e =~ /\A\/?(log|db\/migrate|tmp|coverage)\//
end

entries.sort.reverse.each do |entry|
  next if skip?(entry)
  next unless File.directory?(entry)

  if File.basename(entry).include?(und_from)
    directories_named << entry
  end
end
directories_named.each do |e|
  files = [e, e.gsub(und_from, und_to)]
  puts files.join(' -> ')
  system("git mv '%s' '%s'" % files)
end

entries.sort.reverse.each do |entry|
  next if skip?(entry)
  next if File.directory?(entry)

  if entry.include?(und_from)
    files_named << entry
  end

end

files_named.each do |e|
  files = [e, e.gsub(und_from, und_to)]
  puts files.join(' -> ')
  system("git mv '%s' '%s'" % files)
end


entries.each do |e|
  next if skip?(e)
  next if File.directory?(e)
  contents_to_translate.each do |rep|
    from, to = *rep
 p   sed = "sed 's|#{from}|#{to}|g' -i '#{e}'"
    system(sed)
  end
end
