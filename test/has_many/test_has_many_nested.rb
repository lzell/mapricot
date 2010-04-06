require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'mapricot'))

class ResponseWithNesting < Mapricot::Base
  has_many :users, :xml
end

class User < Mapricot::Base
  has_one :id,    :integer
  has_one :name
end

class TestResponseWithNesting < Test::Unit::TestCase
  
  def setup
    @parsers = [:hpricot, :nokogiri, :libxml]
    @xml = %(
      <response>
        <user>
          <id>10</id>
          <name>bob</name>
        </user>
        <user>
          <id>20</id>
          <name>sally</name>
        </user>
      </response>
    )
  end
  
  
  def test_response
    @parsers.each do |parser|
      Mapricot.parser = parser
      response = ResponseWithNesting.new(@xml)
      assert_equal  10,       response.users[0].id
      assert_equal  "bob",    response.users[0].name
      assert_equal  20,       response.users[1].id
      assert_equal  "sally",  response.users[1].name
    end
  end

  # ---------------- stop reading here ---------------- # 





  
  def test_response_internals
    response = ResponseWithNesting.new(@xml)
    template = response.class.association_list.first

    assert_equal  :users,     template.name
    assert_equal  :xml,       template.type
    assert_nil                template.namespace
    assert_nil                template.value
  
    ass = response.instance_variable_get(:@associations).first
    assert_equal  :users,     ass.name
    assert_equal  :xml,       ass.type
    assert_nil                ass.namespace
    assert_not_nil            ass.value
  end
  
  def test_response_users_internals
    response = ResponseWithNesting.new(@xml)
    template = response.users.first.class.association_list.first
    assert_equal  :id,        template.name
    assert_equal  :integer,   template.type
    assert_nil                template.namespace
    assert_nil                template.value

    ass = response.users.first.instance_variable_get(:@associations).first
    assert_equal  :id,        ass.name
    assert_equal  :integer,   ass.type
    assert_nil                ass.namespace
    assert_equal  10,         ass.value
  end

end
