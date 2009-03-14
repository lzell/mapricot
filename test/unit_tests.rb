require '../lib/mapricot'
# require 'test/unit'



class FeedA < Mapricot::Base
  has_one :bar
end
# 
# class TestFeedA < Test::Unit::TestCase
#   def test_b
#     feeda = FeedA.new(:xml => "<notag></notag>")
#     assert feeda.respond_to?(:bar)
#     puts feeda.bar.inspect
#     assert feeda.bar.nil?
#   end
#   def test_a
#     FeedA.new(:xml => "<bar></bar>")
#   end
# end

feedx = FeedA.new(:xml => "<bar>always see me</bar>")
feedy = FeedA.new(:xml => "<notag>never see me</notag>")
# puts feedx.bar
# puts feedy.bar
# 
# 
# 
# feedb = FeedA.new(:xml => "<bar></bar>")
# feeda = FeedA.new(:xml => "<notag></notag>")
# puts feeda.bar.inspect
# puts feedb.bar.inspect



# class TestFeedA < Test::Unit::TestCase
#   def test_nil_bar
#     feeda = FeedA.new(:xml => "<notag></notag>")
#     assert feeda.respond_to?(:bar)
#     puts feeda.bar.inspect
#     assert feeda.bar.nil?
#   end
#   
#   def test_empty_bar
#     FeedA.new(:xml => "<bar></bar>")
#     # feeda = 
#     # assert feeda.respond_to?(:bar)
#     # assert feeda.bar.empty?
#   end
#   # 
#   # def test_full_bar
#   #   @feed = FeedA.new(:xml => "<bar>is full</bar>")
#   #   assert @feed.respond_to?(:bar)
#   #   assert @feed.bar.is_a?(String)
#   #   assert_equal @feed.bar, "is full"
#   # end
# end
# 
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
