require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../lib/mapricot")


class FeedA < Mapricot::Base
  has_one :bar
end

class TestFeedA < Test::Unit::TestCase
  
  def test_no_bar
    feeda = FeedA.new(:xml => "<no></no>")
    assert feeda.bar.nil?
  end
  
  def test_empty_bar
    feeda = FeedA.new(:xml => "<bar></bar>")
    assert feeda.bar.empty?
  end
  
  def test_full_bar
    @feed = FeedA.new(:xml => "<bar>is full</bar>")
    assert_equal "is full", @feed.bar
  end
end




class FeedB < Mapricot::Base
  has_many :bars
end

class TestFeedB < Test::Unit::TestCase
  def test_many_empty_bars
    feedb = FeedB.new(:xml => "<notag></notag>")
    assert feedb.bars.is_a?(Array)
    assert feedb.bars.empty?
  end
  
  def test_full_bars
    feedb = FeedB.new(:xml => %(
      <response>
        <bar>wet</bar>
        <bar>full</bar>
      </response>
    ))
    
    assert_equal "wet", feedb.bars.first
    assert_equal "full", feedb.bars.last
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
    feedc = FeedC.new(:xml => "<no></no>")
    assert feedc.bars.empty?
  end
  
  def test_many_bars
    feedc = FeedC.new(:xml => %(
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
