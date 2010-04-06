require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'mapricot'))

# !!!!!!!!!!!!!!!!!!
# Please look at test_mapricot_readme.rb first!!
# !!!!!!!!!!!!!!!!!!

# Add test to parse uri, I'll use Natural Inputs as the example: 
module NI
  class NaturalInputsResponse < Mapricot::Base
    has_one   :message
    has_many  :occurrences, :xml
  end

  class Occurrence < Mapricot::Base
    has_one   :type
    has_one   :start_date
    has_one   :end_date
    has_one   :start_time
    has_one   :end_time
    has_one   :day_of_week
    has_one   :week_of_month,   :integer
    has_one   :date_of_month,   :integer
    has_one   :interval,        :integer
  end
end

class TestNI < Test::Unit::TestCase

  def setup
    query = "go to the park tomorrow at 10am"
    now = Time.local(2010, 'Apr', 6)
    @url = "http://naturalinputs.com/query?q=#{URI.escape(query)}&t=#{now.strftime("%Y%m%dT%H%M%S")}"
  end

  def test_url_parsing
    require 'open-uri'

    [:hpricot, :nokogiri, :libxml].each do |parser|
      Mapricot.parser = parser
      response = NI::NaturalInputsResponse.new(open(@url))
      assert_equal "go to the park", response.message
      assert_equal "20100407",  response.occurrences.first.start_date
      assert_equal "10:00:00",  response.occurrences.first.start_time
    end
  end
end



class FeedA < Mapricot::Base
  has_one :name
end

class TestFeedA < Test::Unit::TestCase
  
  def test_no_name
    feeda = FeedA.new("<notag></notag>")
    assert feeda.name.nil?
  end
  
  def test_empty_name
    feeda = FeedA.new("<name></name>")
    assert feeda.name.empty?
  end
  
  def test_full_name
    @feed = FeedA.new("<name>Lou</name>")
    assert_equal "Lou", @feed.name
  end
end


class FeedB < Mapricot::Base
  has_many :names
end

class TestFeedB < Test::Unit::TestCase
  def test_many_empty_names
    feedb = FeedB.new("<notag></notag>")
    assert feedb.names.is_a?(Array)
    assert feedb.names.empty?
  end
  
  def test_full_names
    xml = %(
      <response>
        <name>Lou</name>
        <name>Pizza the Hut</name>
      </response>
    )
    feedb = FeedB.new(xml)
    
    assert_equal "Lou", feedb.names.first
    assert_equal "Pizza the Hut", feedb.names.last
  end
end



class FeedC < Mapricot::Base
  has_many :bars, :xml
end

class Bar < Mapricot::Base
  has_one   :name
  has_many  :patrons
end

class TestFeedC < Test::Unit::TestCase
  def test_many_empty_bars
    feedc = FeedC.new("<no></no>")
    assert feedc.bars.empty?
  end
  
  def test_many_bars
    feedc = FeedC.new(%(
      <response>
        <bar>
          <name>maroon saloon</name>
          <patron>brett</patron>
          <patron>chris</patron>
          <patron>garon</patron>
          <patron>mitch</patron>
        </bar>
      </response>
    ))
    assert_equal "maroon saloon", feedc.bars.first.name
    assert_equal ['brett', 'chris', 'garon', 'mitch'], feedc.bars.first.patrons
  end
end




