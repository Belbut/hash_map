class HashMap
  attr_accessor :buckets, :load_factor

  def initialize
    @buckets = clean_hash_map
    @load_factor = 0
    @capacity = 16
  end

  def set(key, value)
    possible_buckets = possible_buckets_of_grownup_hashmap(key)

    index = possible_buckets.find_index { |bucket| bucket.has?(key) } || 0
    possible_buckets[index].set(key, value)

    update_load_factor
    grow_buckets
    "#{key}:#{value}"
  end

  def has?(key)
    possible_buckets = possible_buckets_of_grownup_hashmap(key)

    possible_buckets.any? { |bucket| bucket.has?(key) }
  end

  # remove(key) takes a key as an argument.
  # If key is in the hash map, it should remove the entry and return the deleted entry’s value.
  # If the key isn’t in the hash map, it should return nil.
  def remove(key)
    possible_buckets = possible_buckets_of_grownup_hashmap(key)

    result = possible_buckets.map { |bucket| bucket.remove(key) }.compact[0]

    update_load_factor
    result
  end

  def length
    buckets.reduce(0) { |sum, linked_list| sum + linked_list.size }
  end

  def clear
    @buckets = clean_hash_map
    @load_factor = 0
    @capacity = 16
  end

  def keys
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.keys) }
  end

  def values
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.values) }
  end

  def entries
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.entries) }
  end

  def to_s
    result = "HashMap load factor:#{(@load_factor * 100).to_i}% / capacity: #{@capacity}\n-----------------------------------\n"
    buckets.each_with_index do |bucket, index|
      result << "[B#{index.to_s.rjust(2, '0')}]-List:#{bucket}"[0..-3]
      result << "\n"
    end
    result
  end

  private

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  # will return an array of possible buckets (due to the growth of the hash table)
  def bucket_index(key)
    hash_code = hash(key)
    multiple_index = []
    index = hash_code % 15 
    (@capacity / 16).times { |i| multiple_index << i * 16 + index }
    raise IndexError if index.negative? || index >= buckets.length

    multiple_index
  end

  def clean_hash_map
    Array.new(16) { LinkedList.new }
  end

  def grow_buckets
    return unless @load_factor > 0.85

    @capacity += 16
    @buckets = clean_hash_map.concat(@buckets)
    update_load_factor
  end

  # return an array with possible buckets
  def possible_buckets_of_grownup_hashmap(key)
    indexes = bucket_index(key)
    indexes.map { |i| buckets[i] }
  end

  def update_load_factor
    @load_factor = length.to_f / @capacity
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

  def values
    accumulator([]) { |result, node| result << node.value }
  end

  def entries
    accumulator([]) { |result, node| result << [node.key, node.value] }
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
