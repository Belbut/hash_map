class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = clean_hash_map
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  def set(key, value)
    index = bucket_index(key)

    buckets[index].set(key, value)
  end

  def has?(key)
    index = bucket_index(key)

    buckets[index].has?(key)
  end

  def remove(key)
    index = bucket_index(key)

    buckets[index].remove(key)
  end

  def length
    buckets.reduce(0) { |sum, linked_list| sum + linked_list.size }
  end

  def clear
    @buckets = clean_hash_map
  end

  def keys
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.keys) }
  end

  def to_s
    result = "-----------------------------------\n"
    buckets.each_with_index do |bucket, index|
      result << "[B#{index.to_s.rjust(2, '0')}]-List:#{bucket}"[0..-3]
      result << "\n"
    end
    result
  end

  private

  def bucket_index(key)
    hash_code = hash(key)
    index = hash_code % 15 && 3
    raise IndexError if index.negative? || index >= buckets.length

    index
  end

  def clean_hash_map
    Array.new(16) { LinkedList.new }
  end
end

class LinkedList
  attr_accessor :next_node, :key, :value

  def initialize(key = :head, value = nil, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end

  def set(key, value)
    slack_node, node = slack_and_node_of_key(key)

    if node.key == key
      slack_node.next_node = Node.new(key, value, node.next_node)
    else
      node.next_node = Node.new(key, value)
    end
  end

  def has?(key)
    node = self
    until node.next_node.nil?
      node = node.next_node

      return true if node.key == key
    end
    false
  end

  def remove(key)
    slack_node, node = slack_and_node_of_key(key)

    return nil if node.key != key

    slack_node.next_node = node.next_node
    node.value
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

class Node
  attr_accessor :key, :value, :next_node

  def initialize(key = nil, value = nil, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end

  def to_s
    "(#{key}:#{value})->#{next_node}"
  end
end
