class HashStructure
  require './linked_list'
  attr_accessor :buckets, :load_factor

  def initialize
    @buckets = clean_hash
    @load_factor = 0
    @capacity = 16
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
    @buckets = clean_hash
    @load_factor = 0
    @capacity = 16
  end

  def keys
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.keys) }
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

  def grow_buckets
    return unless @load_factor > 0.85

    @capacity += 16
    @buckets = clean_hash.concat(@buckets)
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

class HashMap < HashStructure
  def clean_hash
    Array.new(16) { MapLinkedList.new }
  end

  def set(key, value)
    possible_buckets = possible_buckets_of_grownup_hashmap(key)

    index = possible_buckets.find_index { |bucket| bucket.has?(key) } || 0
    possible_buckets[index].set(key, value)

    update_load_factor
    grow_buckets
    "#{key}:#{value}"
  end

  def values
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.values) }
  end

  def entries
    buckets.reduce([]) { |result, linked_list| result.concat(linked_list.entries) }
  end
end

class HashSet < HashStructure
  def clean_hash
    Array.new(16) { SetLinkedList.new }
  end

  def set(key)
    possible_buckets = possible_buckets_of_grownup_hashmap(key)

    index = possible_buckets.find_index { |bucket| bucket.has?(key) } || 0
    possible_buckets[index].set(key)

    update_load_factor
    grow_buckets
    key.to_s
  end
end
