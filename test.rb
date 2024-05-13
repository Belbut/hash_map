require './hash_map.rb'

print `clear`
hm = HashMap.new
hm.set("Carla",27)
hm.set("Carlos",28)
hm.set("Carlay",22)

puts hm

puts hm.remove("dasd")
puts hm.remove("Carla")

puts hm.size

hm.clear
puts hm
puts hm.size
