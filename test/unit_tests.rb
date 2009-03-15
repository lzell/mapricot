require '../lib/mapricot'
require '../lib/abstract_doc'
require 'test/unit'



class FeedA < Mapricot::Base
  has_one :bar
end

class TestFeedA < Test::Unit::TestCase
  
  def test_no_bar
    feeda = FeedA.new(:xml => "<no></no>")
    assert feeda.respond_to?(:bar)
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




# 
# class FeedB < Mapricot::Base
#   has_many :bars
# end
# 
# class TestFeedB < Test::Unit::TestCase
#   def test_many_empty_bars
#     @feed = FeedB.new(:xml => "<notag></notag>")
#   end
# end
# 
# class MoreFoo < Mapricot::Base
#   has_many :bars
# end
# 
# class TestMoreFoo < Test::Unit::TestCase
#   def test_more_empty_bars
#     @mf = MoreFoo.new(:xml => "<foo></foo>")
#     assert @mf.respond_to?(:bars)
#     assert @mf.bars.is_a?(Array)
#     assert @mf.bars.empty?
#   end
#   
#   def test_more_full_bars
#     @mf = MoreFoo.new(:xml => "<foo><bar>wet</bar><bar>full</bar></foo>")
#     assert @mf.bars.is_a?(Array)
#     assert !@mf.bars.empty?
#   end
#   
# end
