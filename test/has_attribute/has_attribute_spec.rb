require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/mapricot")

include Mapricot

class Response < Mapricot::Base
  has_one   :location, :xml
end

class Location < Mapricot::Base
  has_one         :city
  has_one         :state
  has_attribute   :code
  has_attribute   :id,    :integer
end


share_as :HasAttribute do 

  describe "; response with location city, state, and code" do 
  
    before(:all) do 
      @response = Response.new(:xml => %(
        <response>
          <location code='nyc' id='100'>
            <city>New York</city>
            <state>NY</state>
          </location>
        </response>
      ))
    end
    
    it "should have location code 'nyc'" do 
      @response.location.city.should == "New York"
      @response.location.state.should == "NY"
      @response.location.code.should == 'nyc'
      @response.location.id.should == 100
    end
  end
end


describe "has attribute, parsing with hpricot" do 
  before(:all) { Mapricot.parser = :hpricot }
  it_should_behave_like HasAttribute
end

describe "has many id, parsing with libxml" do 
  before(:all) { Mapricot.parser = :libxml }
  it_should_behave_like HasAttribute
end

describe "has many id, parsing with nokogiri" do 
  before(:all) { Mapricot.parser = :nokogiri }
  it_should_behave_like HasAttribute
end
