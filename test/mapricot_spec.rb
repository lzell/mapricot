require '../lib/mapricot'
require 'spec'

# Using a Facebook example:
XML = %(
<?xml version="1.0" encoding="UTF-8"?>
  <users_getInfo_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
    <user>
      <uid>8055</uid>
      <about_me>This field perpetuates the glorification of the ego. Also, it has a character limit.</about_me>
      <activities>Here: facebook, etc. There: Glee Club, a capella, teaching.</activities>
      <affiliations list="true">
        <affiliation>
          <nid>50453093</nid>
          <name>Facebook Developers</name>
          <type>work</type>
          <status/>
          <year/>
        </affiliation>
      </affiliations>
      <birthday>November 3</birthday>
      <books>The Brothers K, GEB, Ken Wilber, Zen and the Art, Fitzgerald, The Emporer's New Mind, The Wonderful Story of Henry Sugar</books>
      <current_location>
        <city>Palo Alto</city>
        <state>CA</state>
        <country>United States</country>
        <zip>94303</zip>
      </current_location> 
    </user>
  </users_getInfo_reponse>
)


class UsersGetInfoResponse < Mapricot::Base
  has_many :users,    :xml
end

class User < Mapricot::Base
  has_one :uid,               :integer
  has_one :about_me,          :string
  has_one :activities,        :string
  has_one :affiliation_list,  :xml,     :tag_name => "affiliations"   # this is cumbersome, do something about this
  has_one :birthday,          :string
  has_one :current_location,  :xml
end

class AffiliationList < Mapricot::Base
  has_many :affiliations,     :xml
end

class Affiliation < Mapricot::Base
  has_one :nid,     :integer
  has_one :name,    :string
  has_one :type,    :string
  has_one :status,  :string
  has_one :year,    :integer
end

class CurrentLocation < Mapricot::Base
  has_one :city,    :string
  has_one :state,   :string
  has_one :country, :string
  has_one :zip,     :integer
end


describe UsersGetInfoResponse do 
  before(:all) { @response = UsersGetInfoResponse.new(:xml => XML) }
  
  it "should respond to users" do 
    @response.should respond_to(:users)
  end
  
  it "should return an array of size 1 when sent users" do 
    @response.users.class.should equal(Array)
    @response.users.size.should equal(1)
  end
end

describe "response.users.first" do 
  before(:all) do 
    response = UsersGetInfoResponse.new(:xml => XML)
    @first_user = response.users.first
  end
  
  it "should be of class User" do
    @first_user.class.should equal(User)
  end
  
  it "should respond to activities" do 
    @first_user.should respond_to(:activities)
    @first_user.activities.should == "Here: facebook, etc. There: Glee Club, a capella, teaching."
  end
  
  it "should respond to current_location" do 
    @first_user.should respond_to(:current_location)
  end
end


describe "response.users.first.current_location" do 
  before(:all) do 
    response = UsersGetInfoResponse.new(:xml => XML)
    @current_location = response.users.first.current_location
  end
  
  it "should have class CurrentLocation" do 
    @current_location.class.should equal(CurrentLocation)
  end

  it "should respond to city, state, country, and zip" do 
    @current_location.city.should == 'Palo Alto'
    @current_location.state.should == 'CA'
    @current_location.country.should == 'United States'
    @current_location.zip.should == 94303
  end
end

