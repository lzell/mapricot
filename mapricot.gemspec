require 'rubygems'

Gem::Specification.new do |s|
  s.name     = "mapricot"
  s.version  = "0.0.0"
  s.date     = "2009-03-06"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.summary  = "XML to object mapper"
  s.email    = "lzell11@gmail.com"
  s.homepage = ""
	s.description = "Makes working with XML stupid easy.  XML to object mapper with an interface similar to ActiveRecord associations."
  s.has_rdoc = true
  s.authors  = ["Lou Zell"]
  s.files    = ["README.txt", 
      "History.txt",
      "License.txt",
      "mapricot.gemspec",
      "examples/lastfm_api.rb",
      "examples/lastfm_api_no_request.rb",
      "examples/natural_inputs.rb",
      "examples/readme_examples.rb",
      "test/mapricot_tests.rb",
      "test/mapricot_spec.rb",
      "lib/mapricot.rb"]
  s.require_paths = ["lib"]
  s.rdoc_options = ["--main", "README.txt", "--inline-source", "--title", "Mapricot"]
  s.extra_rdoc_files = ["README.txt"]
end

