require 'open-uri'
begin
  require 'hpricot'
rescue LoadError
  require 'rubygems'
  require 'hpricot'
end
# singularize, constantize, camelize, classify; doc here: http://api.rubyonrails.com/classes/Inflector.html
require 'active_support/inflector'

module Mapricot

  # Inherit from base, e.g. class Animal < Mapricot::Base
  # Use either a string of xml or a url to initialize
  class Base
    class << self
      # @associations is used to initialize instance variables
      # creates a new HasOneAssociation and appends it to the @associations list
      def has_one(name, type = :string, opts = {})
        ass = HasOneAssociation.new(name, type, opts)
        self.name.match(/::/) && ass.namespace = self.name.match(/(.*)::[^:]+$/)[1]
        associations << ass
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      # creates a new HasManyAssociation and appends it to the @associations list
      def has_many(name, type = :string, opts = {})
        ass = HasManyAssociation.new(name, type, opts)
        self.name.match(/::/) && ass.namespace = self.name.match(/(.*)::[^:]+$/)[1]
        associations << ass
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      def has_attribute(name)
        attributes << name
        class_eval "attr_reader :#{name}", __FILE__, __LINE__
      end
      def associations
        @associations ||= []
      end
      def attributes
        @attributes ||= []
      end
    end

    # class SomeClass < Mapricot::Base; end;
    # SomeClass.new :url => "http://some_url"
    # SomeClass.new :xml => %(<hi></hi>)
    def initialize(opts)
      @xml = Hpricot::XML(open(opts[:url])) if opts[:url]
      @xml = Hpricot::XML(opts[:xml]) if opts[:xml]
      load_associations   
      load_attributes
    end
    
    # searches xml for a tag with association.name, sets association.value to the inner html of this tag and typecasts it
    def load_has_one(has_one_association)
      has_one_association.search(@xml)
    end
    
    def load_has_many(has_many_association)
      has_many_association.search(@xml)
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
        val = (@xml/self.class.name.downcase.match(/[^:]+$/)[0]).first.attributes[att.to_s]
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
  
    def typecast
      raise "association type is invalid" unless VALID_TYPES.include?(@type)
      if [:integer, :time].include?(@type)
        @value = self.send("typecast_#{@type}")
      end
    end
    
    def typecast_integer
      @value.is_a?(Array) ? @value.collect {|v| v.to_i} : @value.to_i
    end
    
    def typecast_time
      if @value.is_a?(Array)
        @value.collect {|v| Time.parse(v) }
      else
        Time.parse(@value)
      end
    end
    
    private
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
    # searches xml for tag name, sets the inner xml as association value and typecasts it
    def search(xml)
      # if tag_name option was passed, use it:
      element = (xml/"#{ @opts[:tag_name] || @name }").first      # class Hpricot::Elements
      if element
        if @type == :xml
          @value = class_from_name.new(:xml => element.to_s)    # we want to include the tag, not just the inner_html
        else
          @value = element.inner_html
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
    
    # searches xml for all occurrences of self.singular_name, the inner xml from each tag is stored in an array and set as the association value
    # finally, each element in the array is typecast
    def search(xml)
      @value = []
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
