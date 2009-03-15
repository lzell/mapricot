require 'rubygems'
require 'libxml'

xml = %(
  <user>
    <pet>cat</pet>
    <pet>dog</pet>
  </user>
)

doc = LibXML::XML::Parser.string(xml).parse
users = doc.find('/user')
puts "users is of class #{users.class}" 
user = users.first
puts "users if of class #{user.class}"
puts user.to_s

#pets = doc.find('/user/pet')
pets = doc.find('//pet')
puts pets.first
pets.each do |pet|
  puts "pet is #{pet.content}"
end


puts "--------------"
puts users.first.attributes.class
puts users.first.attributes.to_h.empty?


puts "--------------"
xml = %(<user>Joe</user>)
doc = LibXML::XML::Parser.string(xml).parse
user = doc.find('//user')
puts user.first.content

