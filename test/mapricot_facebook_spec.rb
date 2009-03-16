# --------------------------------------------------------
#     Look at test_mapricot_readme.rb first!
# ---------------------------------------------------------
require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/mapricot")

# Using a Facebook example
# This xml is taken straight from here: http://wiki.developers.facebook.com/index.php/Users.getInfo
# Note, libxml does not like this for some reason:
# <users_getInfo_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
# So 'xmlns="http://api.facebook.com/1.0/"' has been stripped from tag
# Because of this, for real requests we will have to use Hpricot only
FACEBOOK_XML = %(<?xml version="1.0" encoding="UTF-8"?>
  <users_getInfo_response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
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
  </users_getInfo_response>
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
  
  before(:all) { @response = UsersGetInfoResponse.new(:xml => FACEBOOK_XML) }
  
  it "should have one user" do 
    @response.users.class.should equal(Array)
    @response.users.size.should equal(1)
  end
  
  
  describe "the user" do 
    
    before(:all) { @user = @response.users.first }
    
    it "should have a uid of 8055" do 
      @user.uid.should == 8055
    end
    
    it "should do some activities" do 
      @user.activities.should == "Here: facebook, etc. There: Glee Club, a capella, teaching."
    end
    
    it "should have a current location" do 
      @user.current_location.city.should == "Palo Alto"
      @user.current_location.state.should == "CA"
      @user.current_location.country.should == "United States"
      @user.current_location.zip.should == 94303
    end
    
    it "should have a Facebook Developers affiliation" do 
      @user.affiliation_list.affiliations.first.name.should == "Facebook Developers"    # remove redundancy
      @user.affiliation_list.affiliations.first.nid.should == 50453093
    end
  end
end