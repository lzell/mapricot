module Mapricot
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
  
end