require '../lib/mapricot'

# super simple
simple_xml = %(
  <user>
    <id>1</name>
    <name>Bob</name>
    <pet>cat</pet>
    <pet>dog</pet>
  </user>
)

class User < Mapricot::Base
  has_one   :id,    :integer
  has_one   :name,  :string
  has_many  :pets,  :string
end

user = User.new(:xml => simple_xml)
puts user.id                # => 1
puts user.id.class          # => Fixnum
puts user.name              # => Bob
puts user.pets.class        # => Array
puts user.pets.join(", ")   # => cat, dog

puts "-------------------"

# A little more realistic
xml = %(
  <user>
    <id>2</name>
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

user = User.new(:xml => xml)
puts user.name            # => Sally
puts user.pets.inspect    # => []
puts user.location.class  # => Location
puts user.location.city   # => New York
puts user.location.state  # => NY
puts user.location.code   # => ny123
puts user.hobbies.class         # => Array
puts user.hobbies.first.class   # => Hobby

user.hobbies.each do |hobby|
  puts "#{hobby.description} for #{hobby.number_of_years} years"
end
# => Skiing for 2 years
# => Hiking for 3 years