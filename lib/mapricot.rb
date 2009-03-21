require 'rubygems'
require 'active_support/inflector'
require File.expand_path(File.dirname(__FILE__) + "/abstract_doc")

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
        if self.name.match(/::/)
          association.namespace = self.name.match(/(.*)::[^:]+$/)[1]
        end
        association_list << association
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      
      def has_attribute(name, type = :string)
        attribute_list << Attribute.new(name, type)
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
    # the class instance variable @association_list is duplicated in every instance of Feed, as the instance variable @associations.
    # i.e. Feed.association_list is the template for feed.associations
    def initialize(opts)
      @doc = AbstractDoc.from_url(opts[:url])     if opts[:url]
      @doc = AbstractDoc.from_string(opts[:xml])  if opts[:xml]
      dup_associations_and_attributes
      map_associations
      map_attributes
    end
    
    def dup_associations_and_attributes
      @associations = self.class.association_list.collect {|x| x.dup}   # do not do this: self.class.association_list.dup 
      @attributes = self.class.attribute_list.collect {|x| x.dup}
    end
    
    def map_associations
      @associations.each do |association|
        node_list = @doc.find(association.tag_name)
        association.set_value_from_node_list(node_list)
        instance_variable_set("@#{association.name}", association.value)
      end
    end
    
    def map_attributes
      @attributes.each do |attribute|
        node = @doc.find(tag_name).first
        attribute.set_value_from_node(node)
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
    end
    
    # associations and base classes both have tag_name method
    def tag_name
      self.class.name.downcase.match(/[^:]+$/)[0]
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

    def tag_name
      @opts[:tag_name] || singular_name
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
    
    def set_value_from_node_list(node_list)
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
  end
  

  class HasManyAssociation < Association

    def singular_name
      "#{@name}".singularize
    end
    
    def set_value_from_node_list(node_list)
      @value = []
      node_list.each do |node|
        if @type == :xml
          @value << class_from_name.new(:xml => node.to_s)
        else
          @value << node.contents
        end
      end
      typecast
    end
  end
  
  
  class Attribute
    attr_accessor :name, :type, :value

    def initialize(name, type)
      @name = name
      @type = type
    end
    
    def set_value_from_node(node)
      @value = node.attributes[name.to_s]
      typecast
    end
    
    private
    def typecast
      if !@value.nil? && !@value.empty? && @type == :integer
        @value = @value.to_i
      end
    end
  end  
end
