require 'hpricot'
require 'libxml'
require 'nokogiri'


module Mapricot
  @parser = :hpricot
  class << self; attr_accessor :parser; end
  
  # AbstractDoc should be able to find tags, get inner tag content. Find all tags (return an array)
  # I think I will also need AbstractNode

  class AbstractDoc

    def initialize(string)
      if Mapricot.parser == :libxml
        string = string.read if string.is_a?(StringIO)
        @udoc = LibXML::XML::Parser.string(string).parse
      elsif Mapricot.parser == :hpricot
        @udoc = Hpricot::XML(string)
      elsif Mapricot.parser == :nokogiri
        @udoc = Nokogiri::XML(string)
      end
    end


    def find(tagname)
      if Mapricot.parser == :libxml
        AbstractNodeList.new(@udoc.find("//#{tagname}"))  # hmm...
      elsif Mapricot.parser == :hpricot
        # AbstractNodeList.new(@udoc/tagname)
        AbstractNodeList.new(@udoc/"//#{tagname}")
      elsif Mapricot.parser == :nokogiri
        AbstractNodeList.new(@udoc.search(tagname))
        # AbstractNodeList.new(@udoc.xpath("//#{tagname}"))
      end
    end
    
  end
  
  
  
  class AbstractNodeList
    include Enumerable
    
    def initialize(node_list)
      @unode_list = node_list
    end

    def each(&block)
      @unode_list.each {|unode| yield(AbstractNode.new(unode))}
    end

    def [](i)
      AbstractNode.new(@unode_list[i])
    end
    
    def first
      AbstractNode.new(@unode_list.first)
    end
    
    def empty?
      @unode_list.empty?
    end
  end
  

  class AbstractNode
    attr_reader :unode

    def initialize(unode) 
      @unode = unode        # unresolved node
    end
    
    def to_s
      @unode.to_s
    end
    
    def attributes
      if Mapricot.parser != :nokogiri
        @unode.attributes
      else
        atts = {}
        @unode.attributes.each {|k,v| atts[k] = v.value}
        atts
      end
    end
    
    def contents
      if Mapricot.parser == :libxml || Mapricot.parser == :nokogiri
        @unode.content
      else
        @unode.inner_html
      end
    end
  end
end
