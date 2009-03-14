require '../lib/mapricot'


xml = %(
<response>
  <user id="32" name="Bob"></user>
  <user id="33" name="Sally"></user>
</response>
)


class Response < Mapricot::Base
  has_many :users, :xml
end

class User < Mapricot::Base
  has_attribute :id
  has_attribute :name
end

response = Response.new(:xml => xml)

response.users.each do |user|
  puts user.name
  puts user.id
end