require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mapricot'))


class ResponseWithManyIds < Mapricot::Base
  has_many :ids,  :integer
end


class TestResponseWithManyIds < Test::Unit::TestCase
  
  def setup
    @parsers = [:hpricot, :nokogiri, :libxml]
    @xml = %(
      <response>
        <id>10</id>
        <id>20</id>
        <id>30</id>
      </response>
    )
  end
  
  def test_response
    @parsers.each do |parser|
      Mapricot.parser = parser
      response = ResponseWithManyIds.new(:xml => @xml)
      assert_equal  10,     response.ids[0]
      assert_equal  20,     response.ids[1]
      assert_equal  30,     response.ids[2]
    end
  end
  
  # ---------------- stop reading here ---------------- # 
  
  
  
  
  
  
  
  def test_internals
    response = ResponseWithManyIds.new(:xml => @xml)
    template = response.class.association_list.first
    assert_equal  :ids,       template.name
    assert_equal  :integer,   template.type
    assert_nil                template.namespace
    assert_nil                template.value

    ass = response.instance_variable_get(:@associations).first
    assert_equal  :ids,         ass.name
    assert_equal  :integer,     ass.type
    assert_nil                  ass.namespace
    assert_equal  [10,20,30],   ass.value
  end
end