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
    @parsers = [:hpricot, :nokogiri, :libxml]
    @xml = %(
      <response>
        <location code='nyc' id='100'>
          <city>New York</city>
          <state>NY</state>
        </location>
      </response>
    )
  end
  
  def test_response
    @parsers.each do |parser|
      Mapricot.parser = parser
      response = Response.new(:xml => @xml)
      assert_equal  "New York",     response.location.city
      assert_equal  "NY",           response.location.state
      assert_equal  "nyc",          response.location.code
      assert_equal  100,            response.location.id
    end
  end
  
end

