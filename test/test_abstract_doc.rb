require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'mapricot'))


class TestAbstractDoc < Test::Unit::TestCase
  
  def test_getting_node_contents
    [:libxml, :nokogiri, :hpricot].each do |parser|
      Mapricot.parser = parser
      @doc = Mapricot::AbstractDoc.new('<user>bob</user>')
      @node = @doc.find(:user).first
      assert_equal "bob",                   @node.contents
      assert_equal "<user>bob</user>",      @node.to_s
    end
  end
  
  def test_node_list
    [:libxml, :nokogiri, :hpricot].each do |parser|
      Mapricot.parser = parser
      @doc = Mapricot::AbstractDoc.new('<response><user>sally</user><user>bob</user></response>')
      @node_list = @doc.find(:user)
      assert_instance_of Mapricot::AbstractNodeList, @node_list
      assert_respond_to @node_list,   :each
      assert_respond_to @node_list,   :first
      assert_respond_to @node_list,   :[]

      @node_list.each do |node|
        assert_instance_of Mapricot::AbstractNode,  node
      end
    
      assert_equal "sally", @node_list[0].contents
      assert_equal "bob",   @node_list[1].contents
    end
  end
  
end
