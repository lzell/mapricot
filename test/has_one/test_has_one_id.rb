require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mapricot'))

class ResponseWithOneId < Mapricot::Base
  has_one :id,  :integer
end


class TestReponseWithOneId < Test::Unit::TestCase
  
  def setup
    @parsers = [:hpricot, :nokogiri, :libxml]
    @xml = %(
      <id>10</id>
    )
  end
  
  def test_response
    @parsers.each do |parser|
      Mapricot.parser = parser
      response = ResponseWithOneId.new(:xml => @xml)
      assert_equal  10,     response.id
    end
  end
end
