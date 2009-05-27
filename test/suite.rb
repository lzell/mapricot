# Usage: ruby suite.rb
path = File.expand_path(File.dirname(__FILE__))

spec_glob = File.join(path, "**", "*_spec.rb")
test_glob = File.join(path, "**", "test_*.rb")

tests = Dir.glob(test_glob)
specs = Dir.glob(spec_glob)

tests.each {|test| system("rg #{test}")}
specs.each {|spec| system("spec --format progress --color #{spec}")}