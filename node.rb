class Node
    attr_accessor :key, :next_node
  
    def initialize(key, next_node = nil)
      @key = key
      @next_node = next_node
    end
  end
  
  class MapNode < Node
    attr_accessor :value
  
    def initialize(key = nil, value = nil, next_node = nil)
      super(key, next_node)
      @value = value
    end
  
    def to_s
      "(#{key}:#{value})->#{next_node}"
    end
  end
  
  class SetNode < Node
    def to_s
      "(#{key})->#{next_node}"
    end
  end