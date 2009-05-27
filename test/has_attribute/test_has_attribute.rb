require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mapricot'))


class Response < Mapricot::Base
  has_one   :location, :xml
end

class Location < Mapricot::Base
  has_one         :city
  has_one         :state
  has_attribute   :code
  has_attribute   :id,    :integer
end

class TestResponse < Test::Unit::TestCase
  
  def setup
    @xml = %(
      <response>
        <location code='nyc' id='100'>
          <city>New York</city>
          <state>NY</state>
        </location>
      </response>
    )
  end
  
  def perform_tests
    response = Response.new(:xml => @xml)
    assert_equal  "New York",     response.location.city
    assert_equal  "NY",           response.location.state
    assert_equal  "nyc",          response.location.code
    assert_equal  100,            response.location.id
  end
  
  def test_response_using_hpricot
    Mapricot.parser = :hpricot
    perform_tests
  end
  
  def test_response_using_libxml
    Mapricot.parser = :libxml
    perform_tests
  end
  
  def test_response_using_nokogiri
    Mapricot.parser = :nokogiri
    perform_tests
  end
  
end

