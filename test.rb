require './hash_map.rb'

hm = HashMap.new
hm.set("Carla",27)
puts hm.length
hm.set("Carlos",28)
hm.set("Carlay",22)
puts hm.length

p hm.keys
p hm.values
p hm.entries
