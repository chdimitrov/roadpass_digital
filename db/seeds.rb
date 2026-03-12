require 'json'

data = JSON.parse(File.read(Rails.root.join('db/data.json')))

data['trips'].each do |trip_data|
  Trip.find_or_create_by!(name: trip_data['name']) do |trip|
    trip.image_url = trip_data['image']
    trip.short_description = trip_data['description']
    trip.long_description = trip_data['long_description'].squish
    trip.rating = trip_data['rating']
  end
end

puts "Seeded #{Trip.count} trips"
