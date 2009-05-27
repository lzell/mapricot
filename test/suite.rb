# Usage: ruby suite.rb
path = File.expand_path(File.dirname(__FILE__))

spec_glob = File.join(path, "**", "*_spec.rb")
test_glob = File.join(path, "**", "test_*.rb")

tests = Dir.glob(spec_glob) + Dir.glob(test_glob)

tests.each {|test| system("ruby #{test}")}
