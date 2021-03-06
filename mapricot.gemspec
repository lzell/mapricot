Gem::Specification.new do |s|
  s.name     = "mapricot"
  s.version  = "0.0.5"
  s.summary  = "XML to object mapper"
  s.email    = "lzell11@gmail.com"
  s.homepage = "http://github.com/lzell/mapricot"
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
  s.add_dependency("hpricot", ">= 0.7")
  s.add_dependency("nokogiri", ">= 1.4.1")
  s.add_dependency("libxml-ruby", ">= 1.1.3")
end
