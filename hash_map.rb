class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(16) { LinkedList.new }
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
end

class LinkedList
  attr_accessor :next_node, :key, :value

  def initialize(key = nil, value = nil, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end

  def set(key, value)
    slack_node = node = self

    until node.next_node.nil? || node.key == key
      slack_node = node
      node = node.next_node
    end

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

  def to_s
    "HEAD=>  #{@next_node}"
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
