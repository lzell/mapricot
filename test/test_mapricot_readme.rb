require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'mapricot'))


# -------------------------- Test Example 1 of README.txt ------------------ #
class SimpleUser < Mapricot::Base
  has_one   :id,    :integer
  has_one   :name,  :string
  has_many  :pets,  :string
end


class TestSimpleUser < Test::Unit::TestCase
  def setup
    xml = %(
      <user>
        <id>1</id>
        <name>Bob</name>
        <pet>cat</pet>
        <pet>dog</pet>
      </user>
    )
    
    @user = SimpleUser.new(xml)
  end
  
  def test_mapping
    assert_equal  1,               @user.id
    assert_equal  "Bob",           @user.name
    assert_equal  ["cat", "dog"],  @user.pets
  end
end
# -------------------------------------------------------------------------- #





# -------------------------- Test Example 2 of README.txt ------------------ #
class User < Mapricot::Base
  has_one   :id,        :integer
  has_one   :name       # Tag type will default to :string
  has_many  :pets
  has_one   :location,  :xml
  has_many  :hobbies,   :xml
end

class Location < Mapricot::Base
  has_attribute :code
  has_one       :city
  has_one       :state
end

class Hobby < Mapricot::Base
  has_one :description,     :string
  has_one :number_of_years, :integer
end

class TestUser < Test::Unit::TestCase
  def setup
    xml = %(
      <user>
        <id>2</id>
        <name>Sally</name>
        <location code="ny123">
          <city>New York</city>
          <state>NY</state>
        </location>
        <hobby>
          <description>Skiing</description>
          <number_of_years>2</number_of_years>
        </hobby>
        <hobby>
          <description>Hiking</description>
          <number_of_years>3</number_of_years>
        </hobby>
      </user>
    )
    
    @user = User.new(xml)
  end
  
  def test_id_and_name
    assert_equal @user.id,    2
    assert_equal @user.name,  "Sally"
  end
  
  def test_location
    assert_equal  @user.location.city,   "New York"
    assert_equal  @user.location.state,  "NY"
    assert_equal  @user.location.code,   "ny123"
  end
  
  def test_hobbies
    assert_equal  @user.hobbies[0].description,      "Skiing"
    assert_equal  @user.hobbies[0].number_of_years,  2
    assert_equal  @user.hobbies[1].description,      "Hiking"
    assert_equal  @user.hobbies[1].number_of_years,  3
  end
  
  def test_pets
    assert  @user.pets.empty?  # Sally has no pets
  end
end  
# -------------------------------------------------------------------------- #
