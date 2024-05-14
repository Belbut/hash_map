require './hash_map'
require 'faker'

hm = HashMap.new

100.times do |_i|
  key = Faker::Name.first_name
  value = Faker::Name.last_name

  hm.set(key, value)
end

puts hm

# need to do the extra credit HashSet
