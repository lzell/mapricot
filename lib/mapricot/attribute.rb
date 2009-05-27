module Mapricot
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
