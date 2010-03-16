Gem::Specification.new do |s|
  s.name     = "mapricot"
  s.version  = "0.0.4"
  s.date     = "2009-05-27"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.summary  = "XML to object mapper"
  s.email    = "lzell11@gmail.com"
  s.homepage = ""
	s.description = "XML to object mapper with an interface similar to ActiveRecord associations."
  s.has_rdoc = true
  s.authors  = ["Lou Zell"]
  s.files    = ["README.rdoc", 
      "History.txt",
      "License.txt",
      "mapricot.gemspec",
      "examples/facebook_api.rb",
      "examples/lastfm_api.rb",
      "examples/lastfm_api_no_request.rb",
      "examples/natural_inputs.rb",
      "examples/readme_examples.rb",
      "examples/xml_with_attributes.rb",
      "test/suite.rb",
      "test/test_abstract_doc.rb",
      "test/test_mapricot.rb",
      "test/test_mapricot_readme.rb",
      "test/has_attribute/test_has_attribute.rb",
      "test/has_many/test_has_many_ids.rb",
      "test/has_many/test_has_many_nested.rb",
      "test/has_one/test_has_one_id.rb",
      "test/has_one/test_has_one_nested.rb",
      "lib/mapricot.rb",
      "lib/mapricot/abstract_doc.rb",
      "lib/mapricot/associations.rb",
      "lib/mapricot/attribute.rb",
      "lib/mapricot/base.rb",
      "benchmark/benchmarks.rb"]
  s.require_paths = ["lib"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "Mapricot"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.add_dependency("hpricot")
  s.add_dependency("nokogiri")
  s.add_dependency("libxml-ruby")
end
