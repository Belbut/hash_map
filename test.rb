require './hash_structure'
require 'faker'

hm = HashMap.new
hm.set("andre","belbut")
hs = HashSet.new
hs.set("andre")

100.times do |_i|
  key = Faker::Name.first_name
  value = Faker::Name.last_name

  hm.set(key, value)
  hs.set(key)
end

puts hm
puts hm.remove("andre")

# need to do the extra credit HashSet
puts hs
puts hs.remove("andre")
