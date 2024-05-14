class LinkedList
  require './node'
  attr_accessor :next_node, :key

  def initialize(key = :head, next_node = nil)
    @key = key
    @next_node = next_node
  end

  def has?(key)
    node = self
    until node.next_node.nil?
      node = node.next_node

      return true if node.key == key
    end
    false
  end

  def remover(key)
    slack_node, node = slack_and_node_of_key(key)

    return nil if node.key != key

    slack_node.next_node = node.next_node
    yield(node)
  end

  def size
    accumulator(0) { |sum| sum + 1 }
  end

  def keys
    accumulator([]) { |result, node| result << node.key }
  end

  def to_s
    "HEAD=>  #{@next_node}"
  end

  private

  # returns the before node (aka slack_node) and the node of key if present [slack_node,node]
  # otherwise return [head,head]
  def slack_and_node_of_key(key)
    slack_node = node = self

    until node.next_node.nil? || node.key == key
      slack_node = node
      node = node.next_node
    end

    [slack_node, node]
  end

  def accumulator(initial_operand)
    node = self
    result = initial_operand

    until node.next_node.nil?
      node = node.next_node
      result = yield(result, node)
    end
    result
  end
end

class MapLinkedList < LinkedList
  attr_accessor :value

  def initialize(key = :head, value = nil, next_node = nil)
    super(key, next_node)
    @value = value
  end

  def set(key, value)
    slack_node, node = slack_and_node_of_key(key)

    if node.key == key
      slack_node.next_node = MapNode.new(key, value, node.next_node)
    else
      node.next_node = MapNode.new(key, value)
    end
  end

  def remove(key)
    remover(key, &:value)
  end

  def values
    accumulator([]) { |result, node| result << node.value }
  end

  def entries
    accumulator([]) { |result, node| result << [node.key, node.value] }
  end
end

class SetLinkedList < LinkedList
  def initialize(key = :head, next_node = nil)
    super(key, next_node)
  end

  def set(key)
    slack_node, node = slack_and_node_of_key(key)

    if node.key == key
      slack_node.next_node = SetNode.new(key, node.next_node)
    else
      node.next_node = SetNode.new(key)
    end
  end

  def remove(key)
    remover(key, &:key)
  end
end
