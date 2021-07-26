# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

State.create([{ name: "NSW" }, { name: "VIC" }, { name: "QLD" }, { name: "WA" }, { name: "SA" }, { name: "ACT" }, { name: "NT" }, { name: "TAS" }])

puts "States populated."

Postcode.create([{ number: 2000, state_id: 1 }, { number: 3000, state_id: 2 }, { number: 4000, state_id: 3 }])

puts "Postcodes populated."

Suburb.create([{ name: "Sydney", postcode_id: 1 }, { name: "Darlinghurst", postcode_id: 1 }, { name: "Melbourne", postcode_id: 2 }, { name: "Brisbane", postcode_id: 3 }])

puts "Suburbs populated."
