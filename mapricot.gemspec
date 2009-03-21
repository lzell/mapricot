Gem::Specification.new do |s|
  s.name     = "mapricot"
  s.version  = "0.0.2"
  s.date     = "2009-03-17"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.summary  = "XML to object mapper"
  s.email    = "lzell11@gmail.com"
  s.homepage = ""
	s.description = "Makes working with XML stupid easy.  XML to object mapper with an interface similar to ActiveRecord associations."
  s.has_rdoc = true
  s.authors  = ["Lou Zell"]
  s.files    = ["README.rdoc", 
      "History.txt",
      "License.txt",
      "mapricot.gemspec",
      "examples/lastfm_api.rb",
      "examples/lastfm_api_no_request.rb",
      "examples/facebook_api.rb",
      "examples/natural_inputs.rb",
      "examples/readme_examples.rb",
      "examples/xml_with_attributes.rb",
      "test/suite.rb",
      "test/abstract_doc_spec.rb",
      "test/test_mapricot.rb",
      "test/test_mapricot_readme.rb",
      "test/has_attribute/has_attribute_spec.rb",
      "test/has_many/has_many_ids_spec.rb",
      "test/has_many/has_many_nested_spec.rb",
      "test/has_one/has_one_id_spec.rb",
      "test/has_one/has_one_user_spec.rb",
      "test/has_one/has_one_nested_spec.rb",
      "lib/mapricot.rb",
      "lib/abstract_doc.rb",
      "benchmark/benchmarks.rb"]
  s.require_paths = ["lib"]
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--title", "Mapricot"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.add_dependency("hpricot")
  s.add_dependency("nokogiri")
  s.add_dependency("libxml-ruby")
end
