# Get events in nyc with:
# http://ws.audioscrobbler.com/2.0/?method=geo.getevents&city=new+york&api_key=YOUR_API_KEY_HERE

# The point of this is to demonstrate mapping xml from a real api response.
# The only difference is you instantiate with:
# Response.new(:url => "http://someurl")
# instead of:
# Response.new(:xml => "some string of xml")

# If you do not have an API key, see examples/lastfm_api_no_request.rb
require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/../lib/mapricot")

class Response < Mapricot::Base
  has_many :events,   :xml
end

class Event < Mapricot::Base
  has_one :title
  has_one :venue,   :xml
end

class Venue < Mapricot::Base
  has_one :name
  has_one :location, :xml
end

class Location < Mapricot::Base
  has_one :city
  has_one :country
  has_one :street
  has_one :postalcode,  :integer
end

response = Response.new(:url => "http://ws.audioscrobbler.com/2.0/?method=geo.getevents&city=new+york&api_key=#{YOUR_API_KEY_HERE}")

response.events.each do |event|
  puts "-------------"
  puts event.title
  puts event.venue.name
  puts event.venue.location.city
end
