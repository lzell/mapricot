require 'open-uri'

begin
  %w(hpricot libxml active_support/inflector).each {|lib| require lib}
rescue LoadError
  %w(rubygems hpricot libxml active_support/inflector).each {|lib| require lib}
end


module Mapricot
  @use_libxml = false
  class << self; attr_accessor :use_libxml; end
  
  # AbstractDoc should be able to find tags, get inner tag content. Find all tags (return an array)
  # I think I will also need AbstractNode

  class AbstractDoc

    def self.from_url(url)
      adoc = new
      adoc.url = url
      adoc
    end

    def self.from_string(string)
      adoc = new
      adoc.string = string
      adoc
    end

    def url=(url)
      if Mapricot.use_libxml
        @udoc = LibXML::XML::Parser.file(url).parse
      else
        @udoc = Hpricot::XML(open(url))
      end
    end

    def string=(string)
      if Mapricot.use_libxml
        @udoc = LibXML::XML::Parser.string(string).parse
      else
        @udoc = Hpricot::XML(string)
      end
    end


    def find(tagname)
      if Mapricot.use_libxml
        AbstractNodeList.new(@udoc.find("//#{tagname}"))  # hmm...
      else
        AbstractNodeList.new(@udoc/tagname)
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
      @unode_list[i]
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
    # unode: unabstracted node
    def initialize(unode)
      @unode = unode
    end
    
    def to_s
      @unode.to_s
    end
    
    def contents
      if Mapricot.use_libxml
        @unode.content
      else
        @unode.inner_html
      end
    end
  end
end