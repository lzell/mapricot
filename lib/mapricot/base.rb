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
end