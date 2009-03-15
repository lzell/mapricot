require 'open-uri'

begin
  %w(hpricot libxml active_support/inflector).each {|lib| require lib}
rescue LoadError
  %w(rubygems hpricot libxml active_support/inflector).each {|lib| require lib}
end

# Todo: modularize anything using hpricot/libxml; i.e. the actual parsing

module Mapricot
  
  
  # Inherit from base, e.g. class Animal < Mapricot::Base
  # Use either a string of xml or a url to initialize
  class Base
    
    class << self
      # @associations is used to initialize instance variables
      # creates a new HasOneAssociation and appends it to the @association_list
      def has_one(name, type = :string, opts = {})
        association = HasOneAssociation.new(name, type, opts)
        if self.name.match(/::/)
          association.namespace = self.name.match(/(.*)::[^:]+$/)[1]
        end
        association_list << association
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      
      # creates a new HasManyAssociation and appends it to the @association_list
      def has_many(name, type = :string, opts = {})
        association = HasManyAssociation.new(name, type, opts)
        self.name.match(/::/) && association.namespace = self.name.match(/(.*)::[^:]+$/)[1]
        association_list << association
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      
      def has_attribute(name)
        attribute_list << name
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      
      def association_list
        @association_list ||= []
      end
      
      def attribute_list
        @attribute_list ||= []
      end
    end

    # class SomeClass < Mapricot::Base; end;
    # SomeClass.new :url => "http://some_url"
    # SomeClass.new :xml => %(<hi></hi>)
    # Even though the self.class.association_list contains instances of HasOne and HasManyAssociations, 
    # these instances are for templating, they should hold no state.
    # well that is not true.
    # the class instance variable @association_list is duplicated in every instance of Feed, as the instance variable @associations.
    # i.e. Feed.association_list is the template for feed.associations
    def initialize(opts)
      @doc = AbstractDoc.from_url(opts[:url])     if opts[:url]
      @doc = AbstractDoc.from_string(opts[:xml])  if opts[:xml]
      @associations = self.class.association_list.collect {|x| x.dup}   # do not do this: self.class.association_list.dup 
      map
    end
    

    def map
      # 1.  Iterate through @associations
      # 2.  Find all tags in @doc with association.name
      # 2.  get the tags contents
      # 3.  use association type to typecast the tags contents
      # 4.  assign this to object instance variable "@#{association.name}"
      @associations.each do |association|
        node_list = @doc.find(association.name)
        association.set_value_from_node_list(node_list)
        instance_variable_set("@#{association.name}", association.value)
      end
    end
        
    
    
    # def map_has_one(association)
    #   tag = @doc.find_first_tag(association.name)
    #   association.set_value(tag.contents)
    # end
    # 
    # def map_has_many(association)
    #   tag = @doc.find_tags(association.name)
    #   association.set_value(tag.contents)
    # end
    
    # def map_has_ones
    #   has_ones = @associations.select {|ass| ass.is_a?(HasOneAssociation)}
    #   has_ones.each do |has_one_ass|
    #     tag = @doc.find_first_tag(has_one_ass.name)
    #     has_one_ass.set_value(tag.contents)
    #   end
    #   
    # end
    
    
    
    def set_object_instance_variables
      @associations = self.class.association_list.dup
      # @associations = self.class.association_list.dup
      # @associations.each do |association|
      #   tag = @doc.find_tag(association.tag_name)
      #   association.set_value(tag.contents)
      # end  
      # 
      # @associations.each do |association|
      #   tag = @doc.find_tag(association.tag_name)
      #   association
      # end
      # self.class.association_list.each do |association|
      #   # use association template to stuff the instance variable @"#{association.name}"
      #   # this involves
      #   # 1.  use association name to find the tag with this name
      #   # 2.  get the tags contents
      #   # 3.  use association type to typecast the tags contents
      #   # 4.  assign this to object instance variable
      #   
      #   tag = @doc.find_tag(association.tag_name)
      #   contents = tag.contents
      #   
      #   
      #   content = @doc.get_tag_content(association.tag_name)
      #   
      #   
      #   instance_variable_set("@#{association.name}")
      # end
      # 
      # self.class.association_list.each do |association|
      #   association.type
      #   association.options
      #   association.name
      #   value = association.descriptive_name_here()
      #   instance_variable_set("@#{association.name}", 1)
      # end
      # 
      # self.class.attribute_list.each do |attribute|
      #   instance_variable_set("@#{attribute.name}", 1)
      # end
    end
    
    # searches xml for a tag with association.name, sets association.value to the inner html of this tag and typecasts it
    def load_has_one(has_one_association)
      has_one_association.search(@doc)
    end
    
    def load_has_many(has_many_association)
      has_many_association.search(@doc)
    end
  
    def load_associations
      # loop through the class's instance variable @attributes, which holds all of our associations
      association_list = self.class.instance_variable_get(:@associations)
      association_list && association_list.each do |ass|
        load_has_one(ass) if ass.is_a?(HasOneAssociation)
        load_has_many(ass) if ass.is_a?(HasManyAssociation)
        # set instance variables and create accessors for each
        instance_variable_set("@#{ass.name}", ass.value)  
      end
    end
    
    def load_attributes
      attr_list = self.class.instance_variable_get(:@attributes)
      attr_list && attr_list.each do |att|
        if USE_LIBXML
          val = @doc.find("/#{self.class.name.downcase.match(/[^:]+$/)[0]}").first.attributes[att.to_s]
        else
          val = (@doc/self.class.name.downcase.match(/[^:]+$/)[0]).first.attributes[att.to_s]
        end
        instance_variable_set("@#{att}", val)
      end
    end
  end
  
  # Abstract class; used to subclass HasOneAssociation and HasManyAssociation
  class Association
    VALID_TYPES = [:integer, :time, :xml, :string]

    attr_accessor :name, :type, :value
    attr_accessor :namespace
    def initialize(name, type, opts = {})
      raise "Don't instantiate me" if abstract_class?
      @name, @type, @opts = name, type, opts
      @namespace = nil
    end
  
    private
    def typecast
      raise "association type is invalid" unless VALID_TYPES.include?(@type)
      if [:integer, :time].include?(@type)
        @value = self.send("typecast_#{@type}")
      end
    end
    
    def typecast_integer
      @value.is_a?(Array) ? @value.collect {|v| v.to_i} : @value.to_i
    end
    
    # oh, forgot about this, need to add to readme
    def typecast_time
      if @value.is_a?(Array)
        @value.collect {|v| Time.parse(v) }
      else
        Time.parse(@value)
      end
    end

    def abstract_class?
      self.class == Association
    end
    
    def singular_name
      @name.to_s
    end
    
    def class_from_name
      # ok, first we have to find how the class that inherited from Mapricot::Base is namespaced
      # the class will an @associations class instance var, that will hold an instance of 
      if @namespace
        "#{@namespace}::#{singular_name.classify}".constantize
      else
        singular_name.classify.constantize
      end
    end
  end
  
  
  class HasOneAssociation < Association
    
    # pass a node list, depending on the type of association
    def set_value_from_node_list(node_list)
      if node_list.empty?
        @value = nil
      else
        if @type == :xml
         @value = class_from_name.new(:xml => node_list.first.to_s)
        else
          @value = node_list.first.contents
          typecast
        end
      end
    end
    
    ## Deprecated .............
    # searches xml for tag name, sets the inner xml as association value and typecasts it
    def search(xml)
      # if tag_name option was passed, use it:
      if USE_LIBXML
        element = xml.find("/#{ @opts[:tag_name] || @name }").first  # class LibXML::XML::Node
        # puts element.inspect
      else
        element = (xml/"#{ @opts[:tag_name] || @name }").first      # class Hpricot::Elements
      end
      if element
        if @type == :xml
          @value = class_from_name.new(:xml => element.to_s)    # we want to include the tag, not just the inner_html
        else
          if USE_LIBXML
            @value = element.content
          else
            @value = element.inner_html
          end
        end
        self.typecast
      end
    end
  end
  
  
  class HasManyAssociation < Association

    def singular_name
      # @name.to_s[0..-2]
      "#{@name}".singularize
    end
    
    # Deprecated ...........
    # searches xml for all occurrences of self.singular_name, the inner xml from each tag is stored in an array and set as the association value
    # finally, each element in the array is typecast
    def search(xml)
      @value = []
      # DRY THIS UP
      if USE_LIBXML
        # puts "---------------"
        # puts xml.to_s
        # puts xml.find("/#{@opts[:tag_name] || self.singular_name}").each {|tag| puts tag.inspect}
        # puts "^^^^^^^^^^^^^^^^^^^^^^^"
        xml.find("/#{@opts[:tag_name] || self.singular_name}").each do |tag|
          if @type == :xml
            @value << class_from_name.new(:xml => tag.to_s)
          else
            @value << tag.content
          end
        end
      else
        (xml/"#{@opts[:tag_name] || self.singular_name}").each do |tag|
          if @type == :xml
            @value << class_from_name.new(:xml => tag.to_s)  # a bit of recursion if the inner xml is more xml
          else
            @value << tag.inner_html   # in the case of a string, integer, etc.
          end
        end
      end
    end
    
  end
end
