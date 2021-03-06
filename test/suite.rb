# Usage:
# ruby suite.rb
# OR
# ruby suite.rb rg
# ^^^ that one is for color, and requires the redgreen gem

path = File.expand_path(File.dirname(__FILE__))

test_glob = File.join(path, "**", "test_*.rb")
tests = Dir.glob(test_glob)

if ARGV[0] != 'rg'
  tests.each {|test| system("ruby -rubygems #{test}")}
else
  tests.each {|test| system("rg #{test}")}
end

# spec_glob = File.join(path, "**", "*_spec.rb")
# specs = Dir.glob(spec_glob)
# specs.each {|spec| system("spec --format progress --color #{spec}")}
