require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mapricot'))

class ResponseWithNesting < Mapricot::Base
  has_one :user, :xml
end

class User < Mapricot::Base
  has_one :name
end


class TestReponseWithNesting < Test::Unit::TestCase
  
  def setup
    @parsers = [:hpricot, :nokogiri, :libxml]
    @xml = %(
      <user>
        <name>bob</name>
      </user>
    )
  end
  
  def test_response
    @parsers.each do |parser|
      Mapricot.parser = parser
      response = ResponseWithNesting.new(:xml => @xml)
      assert_equal  "bob",     response.user.name
    end
  end
end
