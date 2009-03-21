require File.expand_path(File.dirname(__FILE__) + "/../lib/mapricot")


last_fm_example = %(
<?xml version="1.0" encoding="utf-8"?>
<lfm status="ok">
<events location="New York, United States" page="1" totalpages="92" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" total="917">
<event>
  <id>895664</id>
  <title>Lydia</title>
  <artists>
    <artist>Lydia</artist>
    <artist>Black Gold</artist>

    <headliner>Lydia</headliner>
  </artists>
  <venue>
    <name>Mercury Lounge</name>
    <location>
      <city>New York</city>
      <country>United States</country>

      <street>217 East Houston Street</street>
      <postalcode>10002</postalcode>
      <geo:point>
         <geo:lat>40.722024</geo:lat>
         <geo:long>-73.98682</geo:long>
      </geo:point>
              <timezone>EST</timezone>

          </location>
    <url>http://www.last.fm/venue/8899833</url>
  </venue>
  <startDate>Thu, 05 Mar 2009</startDate>
  <startTime>18:30</startTime>
  <description><![CDATA[<div class="bbcode">On Sale Fri 1/16 at Noon<br />
21+<br />
$10<br />
Doors 6:30pm/ Show 7:30pm</div>]]></description>
  <image size="small">http://userserve-ak.last.fm/serve/34/9158303.jpg</image>

  <image size="medium">http://userserve-ak.last.fm/serve/64/9158303.jpg</image>
  <image size="large">http://userserve-ak.last.fm/serve/126/9158303.jpg</image>
   <attendance>7</attendance>
   <reviews>0</reviews>
   <tag>lastfm:event=895664</tag>  
  <url>http://www.last.fm/event/895664</url>

</event>
<event>
  <id>924763</id>
  <title>Stars Like Fleas</title>
  <artists>
    <artist>Stars Like Fleas</artist>

    <artist>Frances</artist>
    <artist>twi the humble feather</artist>
    <artist>La Strada</artist>
    <headliner>Stars Like Fleas</headliner>
  </artists>
  <venue>
    <name>Music Hall of Williamsburg</name>

    <location>
      <city>Brooklyn, NY</city>
      <country>United States</country>
      <street>66 North 6th Street</street>
      <postalcode>11211</postalcode>
      <geo:point>
         <geo:lat>40.719308</geo:lat>

         <geo:long>-73.961607</geo:long>
      </geo:point>
              <timezone>EST</timezone>
          </location>
    <url>http://www.last.fm/venue/8851989</url>
  </venue>
  <startDate>Thu, 05 Mar 2009</startDate>

  <startTime>19:00</startTime>
  <description><![CDATA[<div class="bbcode">Doors 7 p.m. / Show 8 p.m.<br />
$10 advance / $12 day of show<br />
18+<br />
<br />
On sale Wed. 2/4 at noon</div>]]></description>
  <image size="small">http://userserve-ak.last.fm/serve/34/3598785.jpg</image>
  <image size="medium">http://userserve-ak.last.fm/serve/64/3598785.jpg</image>
  <image size="large">http://userserve-ak.last.fm/serve/126/3598785.jpg</image>
   <attendance>1</attendance>

   <reviews>0</reviews>
   <tag>lastfm:event=924763</tag>  
  <url>http://www.last.fm/event/924763</url>
</event>
</events></lfm>

)


class Response < Mapricot::Base
  has_many :events, :xml
end

class Event < Mapricot::Base
  has_one :id,              :integer
  has_one :title,           :string
  has_one :artist_group,    :xml,       :tag_name => "artists"
  has_one :venue,           :xml
end

class ArtistGroup < Mapricot::Base
  has_many  :artists,       :string
  has_one   :headliner,     :string
end

class Venue < Mapricot::Base
  has_one   :name,          :string
end

lfm = Response.new(:xml => last_fm_example)
lfm.events.each do |event|
  puts "-------------------------------"
  puts event.title
  puts event.artist_group.artists.inspect
  puts event.venue.name
end
