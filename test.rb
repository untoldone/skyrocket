begin
  gem "listen", ">=0.4.2"
rescue Gem::LoadError => e
  puts "Requires gem"
end

Listen.to('.') do |modified, added, removed|
  puts "modified: #{modified}, added: #{added}, removed: #{removed}"
end
